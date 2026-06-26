const SUPABASE_URL = 'https://tkljcmmljxmfxcixynoe.supabase.co';
const SUPABASE_KEY = 'sb_publishable_qlvtGzbYOsOSGNq3YFAyxQ_jSY6ujJs';

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_KEY);
