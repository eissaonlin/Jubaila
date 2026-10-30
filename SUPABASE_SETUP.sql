-- نفّذ هذا الملف مرة واحدة في Supabase Dashboard > SQL Editor
create table if not exists public.farm_backups (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.farm_backups enable row level security;

-- كل حساب يستطيع قراءة وتعديل نسخته فقط
 drop policy if exists "Users read own farm backup" on public.farm_backups;
create policy "Users read own farm backup"
  on public.farm_backups for select to authenticated
  using (auth.uid() = user_id);

 drop policy if exists "Users insert own farm backup" on public.farm_backups;
create policy "Users insert own farm backup"
  on public.farm_backups for insert to authenticated
  with check (auth.uid() = user_id);

 drop policy if exists "Users update own farm backup" on public.farm_backups;
create policy "Users update own farm backup"
  on public.farm_backups for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

grant select, insert, update on public.farm_backups to authenticated;
