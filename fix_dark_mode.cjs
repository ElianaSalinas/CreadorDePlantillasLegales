const fs = require('fs');

function addDarkClasses(file) {
  let content = fs.readFileSync(file, 'utf8');
  
  // Replace some common light mode classes with their dark mode counterparts
  content = content.replace(/className="bg-surface/g, 'className="bg-[#fcf9f8] dark:bg-slate-900');
  content = content.replace(/text-on-surface-variant/g, 'text-slate-600 dark:text-slate-400');
  content = content.replace(/text-on-surface/g, 'text-slate-800 dark:text-slate-200');
  content = content.replace(/bg-surface\/80/g, 'bg-[#fcf9f8]/80 dark:bg-slate-900/80');
  content = content.replace(/bg-white\b/g, 'bg-white dark:bg-slate-900');
  content = content.replace(/bg-\[\#fcf9f8\]/g, 'bg-[#fcf9f8] dark:bg-slate-900');
  content = content.replace(/bg-\[\#fcf9f8\]\/80/g, 'bg-[#fcf9f8]/80 dark:bg-slate-900/80');
  content = content.replace(/border-slate-200/g, 'border-slate-200 dark:border-slate-800');
  content = content.replace(/border-outline-variant/g, 'border-slate-200 dark:border-slate-800');
  content = content.replace(/text-\[\#0D2C24\]/g, 'text-[#0D2C24] dark:text-emerald-400');
  content = content.replace(/hover:text-\[\#0D2C24\]/g, 'hover:text-[#0D2C24] dark:hover:text-emerald-300');
  content = content.replace(/text-slate-600/g, 'text-slate-600 dark:text-slate-400');
  content = content.replace(/bg-slate-50\b/g, 'bg-slate-50 dark:bg-slate-800');
  content = content.replace(/bg-slate-100\b/g, 'bg-slate-100 dark:bg-slate-800');
  content = content.replace(/text-slate-800/g, 'text-slate-800 dark:text-slate-200');
  content = content.replace(/text-slate-500/g, 'text-slate-500 dark:text-slate-400');

  fs.writeFileSync(file, content);
}

addDarkClasses('src/components/WelcomePage.tsx');
addDarkClasses('src/components/PricingPage.tsx');
console.log('Added dark mode classes');
