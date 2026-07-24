-- 1) books table -------------------------------------------------
create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  title text not null,
  author text,
  pages integer,
  status text not null default 'reading',
  color_key text,
  genre text,
  genre_color text,
  cover_url text,
  rating integer default 0,
  note text default '',
  start_date date,
  finish_date date,
  created_at timestamptz default now()
);

alter table public.books enable row level security;

create policy "Users can view own books"
  on public.books for select
  using (auth.uid() = user_id);

create policy "Users can insert own books"
  on public.books for insert
  with check (auth.uid() = user_id);

create policy "Users can update own books"
  on public.books for update
  using (auth.uid() = user_id);

create policy "Users can delete own books"
  on public.books for delete
  using (auth.uid() = user_id);

-- 2) storage bucket for cover images ------------------------------
-- Create the bucket first from the Supabase dashboard:
--   Storage → New bucket → name: "covers" → Public bucket: ON
-- Then run the policies below (Storage → Policies → New policy,
-- or just run this SQL in the SQL editor).

create policy "Public read covers"
  on storage.objects for select
  using (bucket_id = 'covers');

create policy "Users upload own covers"
  on storage.objects for insert
  with check (
    bucket_id = 'covers'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Users update own covers"
  on storage.objects for update
  using (
    bucket_id = 'covers'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Users delete own covers"
  on storage.objects for delete
  using (
    bucket_id = 'covers'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
