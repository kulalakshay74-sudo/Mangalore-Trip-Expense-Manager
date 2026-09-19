-- Mangalore Trip Expense Manager: secure Supabase schema
create table if not exists public.trip_members(id uuid primary key default gen_random_uuid(),name text not null,group_name text not null default 'Boys' check(group_name in('Boys','Girls')),expected numeric(12,2) not null default 0,paid numeric(12,2) not null default 0,created_at timestamptz not null default now());
create table if not exists public.trip_expenses(id uuid primary key default gen_random_uuid(),name text not null,amount numeric(12,2) not null default 0,note text default '',created_at timestamptz not null default now());
create table if not exists public.admin_users(user_id uuid primary key references auth.users(id) on delete cascade,created_at timestamptz not null default now());
alter table public.trip_members enable row level security; alter table public.trip_expenses enable row level security; alter table public.admin_users enable row level security;
create or replace function public.is_admin() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from public.admin_users where user_id=auth.uid()); $$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon,authenticated;
drop policy if exists "Public can view members" on public.trip_members; create policy "Public can view members" on public.trip_members for select to anon,authenticated using(true);
drop policy if exists "Admin can insert members" on public.trip_members; create policy "Admin can insert members" on public.trip_members for insert to authenticated with check(public.is_admin());
drop policy if exists "Admin can update members" on public.trip_members; create policy "Admin can update members" on public.trip_members for update to authenticated using(public.is_admin()) with check(public.is_admin());
drop policy if exists "Admin can delete members" on public.trip_members; create policy "Admin can delete members" on public.trip_members for delete to authenticated using(public.is_admin());
drop policy if exists "Public can view expenses" on public.trip_expenses; create policy "Public can view expenses" on public.trip_expenses for select to anon,authenticated using(true);
drop policy if exists "Admin can insert expenses" on public.trip_expenses; create policy "Admin can insert expenses" on public.trip_expenses for insert to authenticated with check(public.is_admin());
drop policy if exists "Admin can update expenses" on public.trip_expenses; create policy "Admin can update expenses" on public.trip_expenses for update to authenticated using(public.is_admin()) with check(public.is_admin());
drop policy if exists "Admin can delete expenses" on public.trip_expenses; create policy "Admin can delete expenses" on public.trip_expenses for delete to authenticated using(public.is_admin());
drop policy if exists "Admin users are private" on public.admin_users; create policy "Admin users are private" on public.admin_users for select to authenticated using(user_id=auth.uid());
insert into public.trip_members(name,group_name,expected,paid) select * from (values
('Akshay','Boys',1500,1500),('Arjun','Boys',1500,0),('Omkar','Boys',1500,1000),('Dhanush G','Boys',1500,1500),('Dhanush S','Boys',1500,0),('Deepak','Boys',1500,1000),('Harsith','Boys',1500,1000),('Yajnesh','Boys',1500,1000),('Mokshith','Boys',1500,0),('Rakesh','Boys',1500,0),('Amisha','Girls',1100,1000),('Dhanya','Girls',1100,1000),('Disha','Girls',1100,1000),('Monisha','Girls',1100,1000),('Sharanya','Girls',1100,1000),('Deeksha','Girls',1100,1000),('Anvitha','Girls',1100,1000)) as v(name,group_name,expected,paid) where not exists(select 1 from public.trip_members);
insert into public.trip_expenses(name,amount,note) select 'Resort',9500,'Preloaded trip expense' where not exists(select 1 from public.trip_expenses);
-- After creating your admin Auth user, replace ADMIN_AUTH_USER_UUID below with that user's UUID and run this line:
-- insert into public.admin_users(user_id) values ('ADMIN_AUTH_USER_UUID') on conflict do nothing;