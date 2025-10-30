-- =================================================================
--                  SCRIPT DE CRÉATION DE LA BASE DE DONNÉES
--                          MATH EASY SN
-- =================================================================

-- -----------------------------------------------------------------
-- TABLE 1: Utilisateurs (users)
-- Stocke les informations d'authentification des utilisateurs.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL CHECK (char_length(username) >= 4 AND char_length(username) <= 15),
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- Commentaire sur la table pour plus de clarté
COMMENT ON TABLE public.users IS 'Contient les informations d''authentification des utilisateurs de l''application.';


-- -----------------------------------------------------------------
-- TABLE 2: Chapitres (chapters)
-- Stocke le contenu des cours.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    -- 'num' pour Numérique, 'geo' pour Géométrique
    section TEXT NOT NULL,
    -- Contenu du cours au format Markdown
    content TEXT,
    "order" SMALLINT -- Pour ordonner les chapitres
);

COMMENT ON TABLE public.chapters IS 'Contient le contenu des cours, y compris les textes au format Markdown.';


-- -----------------------------------------------------------------
-- TABLE 3: Exercices (exercises)
-- Stocke tous les exercices liés aux chapitres.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chapter_slug TEXT NOT NULL REFERENCES public.chapters(slug) ON DELETE CASCADE,
    question TEXT NOT NULL,
    -- 'qcm', 'input', 'true_false'
    exercise_type TEXT NOT NULL,
    -- Stocke les options pour les QCM au format JSON
    options JSONB,
    correct_answer TEXT NOT NULL,
    explanation TEXT
);

COMMENT ON TABLE public.exercises IS 'Banque de questions pour les exercices de chaque chapitre.';


-- -----------------------------------------------------------------
-- TABLE 4: Progression de l'utilisateur (user_progress)
-- Enregistre les scores des utilisateurs pour les exercices et les quiz.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_progress (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    -- Ex: 'racine-carree' pour un chapitre, 'bfem-2023' pour un quiz
    entity_id TEXT NOT NULL,
    score INT NOT NULL,
    total INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

COMMENT ON TABLE public.user_progress IS 'Historique des scores des utilisateurs par chapitre ou par quiz.';


-- -----------------------------------------------------------------
-- ACTIVER RLS (Row Level Security)
-- C'est une bonne pratique de sécurité sur Supabase.
-- -----------------------------------------------------------------
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

-- -----------------------------------------------------------------
-- POLITIQUES DE SÉCURITÉ (POLICIES)
-- Pour l'instant, on autorise l'accès en lecture à tout utilisateur
-- authentifié pour les chapitres et exercices.
-- Les politiques d'écriture et de lecture des données utilisateur seront
-- gérées via les Edge Functions pour plus de sécurité.
-- -----------------------------------------------------------------

-- Les utilisateurs authentifiés peuvent lire les chapitres et les exercices.
CREATE POLICY "Allow authenticated read access to chapters"
ON public.chapters FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated read access to exercises"
ON public.exercises FOR SELECT
TO authenticated
USING (true);

-- Les utilisateurs ne peuvent voir que leur propre progression.
CREATE POLICY "Allow individual read access on user_progress"
ON public.user_progress FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Les utilisateurs ne peuvent insérer que leur propre progression.
CREATE POLICY "Allow individual insert access on user_progress"
ON public.user_progress FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);


-- =================================================================
-- FIN DU SCRIPT
-- =================================================================