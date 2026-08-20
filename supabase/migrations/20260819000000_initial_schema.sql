-- ==========================================
-- SA&VE Comercial, S.R.L. - Initial Schema
-- ==========================================

-- 1. ENUMS
CREATE TYPE professional_role AS ENUM ('ABOGADO', 'NOTARIO', 'AMBOS');
CREATE TYPE member_role AS ENUM ('OWNER', 'PARALEGAL', 'ASSISTANT');
CREATE TYPE doc_status AS ENUM ('DRAFT', 'IN_REVIEW', 'APPROVED', 'FINAL');
CREATE TYPE sub_status AS ENUM ('FREE', 'PREMIUM', 'CANCELLED');

-- 2. EXTENDING SUPABASE AUTH USERS (PROFILES)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR UNIQUE NOT NULL,
  first_name VARCHAR,
  last_name VARCHAR,
  phone VARCHAR,
  prof_role professional_role, -- Solo si es dueño/profesional
  card_number VARCHAR, -- Matrícula CARD si aplica
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Habilitar RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone."
  ON profiles FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile."
  ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile."
  ON profiles FOR UPDATE USING (auth.uid() = id);


-- 3. ORGANIZATIONS (MULTI-TENANT)
CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  sub_status sub_status DEFAULT 'FREE',
  docs_generated_count INT DEFAULT 0,
  free_limit INT DEFAULT 10,
  vault_limit INT DEFAULT 30,
  require_approval BOOLEAN DEFAULT true, -- Configuración de despacho
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owners can view own organization"
  ON organizations FOR SELECT
  USING (auth.uid() = owner_id);

CREATE POLICY "Owners can update own organization"
  ON organizations FOR UPDATE
  USING (auth.uid() = owner_id);


-- 4. ORGANIZATION MEMBERS (PARALEGALS/ASSISTANTS)
CREATE TABLE org_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role member_role DEFAULT 'PARALEGAL',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(org_id, user_id)
);

ALTER TABLE org_members ENABLE ROW LEVEL SECURITY;

-- Miembros pueden ver su organización
CREATE POLICY "Members can view their org members"
  ON org_members FOR SELECT
  USING (
    user_id = auth.uid() OR 
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid()) OR
    org_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid())
  );


-- 5. TEMPLATES (MASTER & CUSTOM)
CREATE TABLE templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE, -- NULL if SA&VE Master Template
  title VARCHAR NOT NULL,
  category VARCHAR NOT NULL,
  is_master BOOLEAN DEFAULT false,
  version VARCHAR DEFAULT '1.0',
  content JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can read master templates"
  ON templates FOR SELECT
  USING (is_master = true OR org_id IN (
    SELECT org_id FROM org_members WHERE user_id = auth.uid()
    UNION
    SELECT id FROM organizations WHERE owner_id = auth.uid()
  ));


-- 6. DOCUMENTS
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  creator_id UUID NOT NULL REFERENCES profiles(id),
  template_id UUID REFERENCES templates(id),
  title VARCHAR NOT NULL,
  status doc_status DEFAULT 'DRAFT',
  data_payload JSONB,
  storage_path VARCHAR,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can read org documents"
  ON documents FOR SELECT
  USING (org_id IN (
    SELECT org_id FROM org_members WHERE user_id = auth.uid()
    UNION
    SELECT id FROM organizations WHERE owner_id = auth.uid()
  ));

CREATE POLICY "Org members can insert documents"
  ON documents FOR INSERT
  WITH CHECK (org_id IN (
    SELECT org_id FROM org_members WHERE user_id = auth.uid()
    UNION
    SELECT id FROM organizations WHERE owner_id = auth.uid()
  ));


-- 7. AUDIT LOGS
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id),
  document_id UUID REFERENCES documents(id) ON DELETE SET NULL,
  action VARCHAR NOT NULL,
  description TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
-- Audit logs are read-only for org members, insert via triggers.

CREATE POLICY "Org members can view audit logs"
  ON audit_logs FOR SELECT
  USING (org_id IN (
    SELECT org_id FROM org_members WHERE user_id = auth.uid()
    UNION
    SELECT id FROM organizations WHERE owner_id = auth.uid()
  ));

-- ==========================================
-- TRIGGERS & FUNCTIONS
-- ==========================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_documents_modtime
BEFORE UPDATE ON documents
FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
