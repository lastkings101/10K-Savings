-- Run this once in Supabase: SQL Editor > New query > paste > Run

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  paycheck int not null check (paycheck between 1 and 26),
  saved_at timestamptz not null default now(),
  primary key (user_id, paycheck)
);

-- Create a profile automatically when someone signs up
create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email) values (new.id, new.email);
  return new;
end $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Helper used by the admin policies (security definer avoids policy recursion)
create function public.is_admin() returns boolean
language sql security definer stable set search_path = public as $$
  select coalesce((select is_admin from public.profiles where id = auth.uid()), false)
$$;

alter table public.profiles enable row level security;
alter table public.progress enable row level security;

-- Profiles: read your own row (admins read all). No update policy, so nobody can make themselves admin.
create policy "read own profile" on public.profiles
  for select using (id = auth.uid() or public.is_admin());

-- Progress: each user manages only their own rows; admins can read all
create policy "read own progress" on public.progress
  for select using (user_id = auth.uid() or public.is_admin());
create policy "add own progress" on public.progress
  for insert with check (user_id = auth.uid());
create policy "remove own progress" on public.progress
  for delete using (user_id = auth.uid());

-- Make YOURSELF the admin: sign up in the app first, then run this with your email
-- update public.profiles set is_admin = true where email = 'you@example.com';
