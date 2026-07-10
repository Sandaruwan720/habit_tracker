-- ─────────────────────────────────────────────────────────────────────────────
-- HabitFlow — Supabase SQL Migration
-- Run this entire script in: Supabase Dashboard → SQL Editor → New Query
-- ─────────────────────────────────────────────────────────────────────────────

-- ── habits table ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.habits (
  id            TEXT        PRIMARY KEY,
  user_id       UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name          TEXT        NOT NULL,
  description   TEXT,
  color         BIGINT      DEFAULT 4282532963,
  icon          TEXT        DEFAULT 'check_circle',
  frequency     TEXT        DEFAULT 'daily',
  target_count  INTEGER     DEFAULT 1,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted    BOOLEAN     DEFAULT FALSE
);

-- ── habit_logs table ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.habit_logs (
  id            TEXT        PRIMARY KEY,
  habit_id      TEXT        NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
  user_id       UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  completed_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  note          TEXT,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted    BOOLEAN     DEFAULT FALSE
);

-- ── Indices (for fast delta pulls by updated_at) ──────────────────────────────

CREATE INDEX IF NOT EXISTS idx_habits_user_updated
  ON public.habits(user_id, updated_at);

CREATE INDEX IF NOT EXISTS idx_logs_user_updated
  ON public.habit_logs(user_id, updated_at);

-- ── updated_at auto-update trigger ───────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS habits_set_updated_at ON public.habits;
CREATE TRIGGER habits_set_updated_at
  BEFORE UPDATE ON public.habits
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS habit_logs_set_updated_at ON public.habit_logs;
CREATE TRIGGER habit_logs_set_updated_at
  BEFORE UPDATE ON public.habit_logs
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
-- ✅  Done.
-- No RLS policies applied as requested.
-- The app uses auth.uid() filtering at the application layer instead.
-- ─────────────────────────────────────────────────────────────────────────────
