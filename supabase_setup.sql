-- SANZONE EXCEL: run this entire script in Supabase Dashboard > SQL Editor.
-- Creates a private Storage bucket and owner-only database/storage policies.

create table if not exists public.sanzone_excel_files (
  id uuid primary key,
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  storage_path text not null unique,
  size_bytes bigint not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.sanzone_excel_files enable row level security;

drop policy if exists "Users can view their own SANZONE files" on public.sanzone_excel_files;
create policy "Users can view their own SANZONE files"
on public.sanzone_excel_files for select to authenticated
using (auth.uid() = owner_id);

drop policy if exists "Users can insert their own SANZONE files" on public.sanzone_excel_files;
create policy "Users can insert their own SANZONE files"
on public.sanzone_excel_files for insert to authenticated
with check (auth.uid() = owner_id);

drop policy if exists "Users can update their own SANZONE files" on public.sanzone_excel_files;
create policy "Users can update their own SANZONE files"
on public.sanzone_excel_files for update to authenticated
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

drop policy if exists "Users can delete their own SANZONE files" on public.sanzone_excel_files;
create policy "Users can delete their own SANZONE files"
on public.sanzone_excel_files for delete to authenticated
using (auth.uid() = owner_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'sanzone-excel',
  'sanzone-excel',
  false,
  52428800,
  array[
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-excel',
    'text/csv',
    'application/octet-stream'
  ]
)
on conflict (id) do update set
  public = false,
  file_size_limit = 52428800;

drop policy if exists "SANZONE users read own objects" on storage.objects;
create policy "SANZONE users read own objects"
on storage.objects for select to authenticated
using (bucket_id = 'sanzone-excel' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "SANZONE users upload own objects" on storage.objects;
create policy "SANZONE users upload own objects"
on storage.objects for insert to authenticated
with check (bucket_id = 'sanzone-excel' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "SANZONE users update own objects" on storage.objects;
create policy "SANZONE users update own objects"
on storage.objects for update to authenticated
using (bucket_id = 'sanzone-excel' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'sanzone-excel' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "SANZONE users delete own objects" on storage.objects;
create policy "SANZONE users delete own objects"
on storage.objects for delete to authenticated
using (bucket_id = 'sanzone-excel' and (storage.foldername(name))[1] = auth.uid()::text);

-- Optional: update timestamp automatically when metadata changes.
create or replace function public.sanzone_excel_set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists sanzone_excel_updated_at on public.sanzone_excel_files;
create trigger sanzone_excel_updated_at
before update on public.sanzone_excel_files
for each row execute function public.sanzone_excel_set_updated_at();
