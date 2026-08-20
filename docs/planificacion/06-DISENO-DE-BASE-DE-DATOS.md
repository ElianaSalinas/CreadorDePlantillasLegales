# 06 - Diseño de Base de Datos (Esquema Supabase / PostgreSQL)
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Módulo de Autenticación y Usuarios
```sql
-- Extiende auth.users de Supabase
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email VARCHAR UNIQUE NOT NULL,
  first_name VARCHAR,
  last_name VARCHAR,
  is_lawyer BOOLEAN DEFAULT false,
  is_notary BOOLEAN DEFAULT false,
  card_number VARCHAR, -- Si es notario
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE organizations (
  id UUID PRIMARY KEY,
  owner_id UUID REFERENCES profiles(id),
  name VARCHAR,
  subscription_status VARCHAR, -- FREE, PREMIUM
  documents_generated_count INT DEFAULT 0, -- Para límite de 10
  vault_limit INT DEFAULT 30
);

CREATE TABLE org_members (
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  user_id UUID REFERENCES profiles(id),
  role VARCHAR -- 'OWNER', 'PARALEGAL', 'ASSISTANT'
);
```

## 2. Módulo Documental
```sql
CREATE TABLE master_templates (
  id UUID PRIMARY KEY,
  title VARCHAR,
  category VARCHAR,
  is_premium BOOLEAN,
  current_version UUID
);

CREATE TABLE template_versions (
  id UUID PRIMARY KEY,
  master_id UUID REFERENCES master_templates(id),
  version_number VARCHAR, -- '1.0', '1.1'
  content JSONB,
  created_at TIMESTAMP
);

CREATE TABLE custom_templates (
  -- Para cuando el usuario copia/modifica o crea desde cero
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  title VARCHAR,
  content JSONB
);

CREATE TABLE documents (
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  creator_id UUID REFERENCES profiles(id),
  template_version_id UUID, -- NULL si es custom
  custom_template_id UUID,
  title VARCHAR,
  status VARCHAR, -- 'DRAFT', 'IN_REVIEW', 'APPROVED', 'FINAL'
  data_payload JSONB,
  storage_path VARCHAR, -- Ruta en Supabase Storage
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

## 3. Módulo de Trazabilidad y Backoffice
```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  user_id UUID REFERENCES profiles(id),
  document_id UUID REFERENCES documents(id),
  action VARCHAR, -- 'CREATED', 'EDITED', 'SENT_TO_REVIEW', 'APPROVED'
  timestamp TIMESTAMP DEFAULT NOW()
);

CREATE TABLE save_admins (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  admin_role VARCHAR -- 'SUPER_ADMIN', 'CONTENT', 'FINANCE'
);
```
