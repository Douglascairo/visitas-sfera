const SUPABASE_URL = 'https://gjzyjlvokxyqnhvureiv.supabase.co';
const SUPABASE_KEY = 'sb_publishable_ZimQtvwFqAvWwBUIBrn-pg_ZTnTF7cg';

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_KEY);
