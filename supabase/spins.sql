-- Ämtchen-Baum: ein Dreh pro Person, über alle Geräte geteilt
create table if not exists public.spins (
  key  text primary key,
  name text not null,
  amt  int  not null check (amt between 0 and 5),
  at   timestamptz not null default now()
);

alter table public.spins enable row level security;

-- Alle dürfen die Ergebnisse lesen
create policy "spins lesen" on public.spins
  for select to anon, authenticated using (true);

-- Alle dürfen einen Dreh eintragen; ändern oder löschen geht nicht
create policy "spins eintragen" on public.spins
  for insert to anon, authenticated with check (true);

-- Live-Aktualisierung auf allen Geräten
alter publication supabase_realtime add table public.spins;
