# MathEasy SN - Application Flutter

Bienvenue dans le projet MathEasy SN ! Cette application a pour but d'aider les élèves de 3ème au Sénégal à préparer l'épreuve de mathématiques du BFEM. Elle est conçue pour être 100% fonctionnelle hors ligne après un premier téléchargement du contenu.

Ce document vous guidera à travers les étapes de configuration du backend, de l'ajout du contenu, et du lancement de l'application.

## Architecture

Le projet est construit sur une **Clean Architecture** avec les couches suivantes :
-   **Presentation :** Contient les écrans (Widgets), la gestion d'état (BLoC).
-   **Domain :** Contient la logique métier (Use Cases) et les contrats (Repositories).
-   **Data :** Contient l'implémentation des repositories et la communication avec les sources de données (Supabase, Hive, SQLite).

## Instructions de Configuration et de Lancement

Suivez ces étapes dans l'ordre pour rendre l'application pleinement fonctionnelle.

### Étape 1 : Configurer le Backend Supabase

1.  **Créez votre projet Supabase :**
    -   Rendez-vous sur [supabase.com](https://supabase.com) et créez un nouveau projet si ce n'est pas déjà fait.

2.  **Exécutez le Script SQL :**
    -   Dans votre projet Supabase, naviguez vers `SQL Editor`.
    -   Cliquez sur `+ New query`.
    -   Copiez l'intégralité du contenu du fichier `supabase_schema.sql` (fourni dans ce projet) et collez-le dans l'éditeur.
    -   Cliquez sur **RUN**. Cela créera toutes vos tables (`users`, `chapters`, `exercises`, `user_progress`) et les règles de sécurité.

3.  **Déployez les Edge Functions :**
    -   Installez la [Supabase CLI](https://supabase.com/docs/guides/cli) sur votre ordinateur.
    -   Ouvrez un terminal à la racine de ce projet Flutter.
    -   Connectez-vous à votre compte Supabase : `supabase login`
    -   Liez votre projet local à votre projet distant : `supabase link --project-ref VOTRE_ID_PROJET` (remplacez `VOTRE_ID_PROJET` par l'ID de votre projet Supabase).
    -   Déployez les fonctions avec la commande :
        ```bash
        supabase functions deploy --no-verify-jwt
        ```
    -   **Alternative (Manuelle) :** Si vous préférez, vous pouvez créer les fonctions `register` et `login` depuis le tableau de bord Supabase et y copier-coller le contenu des fichiers `index.ts` correspondants situés dans le dossier `supabase/functions/`.

4.  **Configurez les Secrets des Fonctions :**
    -   Dans votre projet Supabase, allez dans `Settings` > `Edge Functions`.
    -   Dans la section "Set secrets", ajoutez les 3 secrets suivants :
        -   `SUPABASE_URL`: L'URL de votre projet.
        -   `SUPABASE_SERVICE_ROLE_KEY`: Votre clé `service_role` (disponible dans `Settings` > `API`).
        -   `SUPABASE_JWT_SECRET`: Votre `JWT Secret` (disponible dans `Settings` > `API`).

### Étape 2 : Ajouter le Contenu Pédagogique

1.  **Remplir les Tables :**
    -   Dans l'éditeur de tables de Supabase, remplissez les tables `chapters` et `exercises` avec votre contenu.
    -   Pour la table `chapters`, le champ `content` doit contenir votre cours au format Markdown.
    -   Pour la table `exercises`, assurez-vous de lier chaque exercice au bon chapitre via le `chapter_slug`.

2.  **Uploader les Épreuves PDF :**
    -   Dans Supabase, allez dans `Storage` et créez un "Bucket" (ex: `epreuves_bfem`). Rendez-le **public**.
    -   Uploadez vos fichiers PDF.
    -   Vous devrez ensuite mettre à jour le code de `lib/presentation/screens/bfem/bfem_screen.dart` pour qu'il pointe vers les bons noms de fichiers.

### Étape 3 : Lancer l'Application Flutter

1.  **Installez les dépendances :**
    ```bash
    flutter pub get
    ```

2.  **Générez les fichiers nécessaires :**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **Lancez l'application avec vos clés Supabase :**
    -   Remplacez les placeholders par vos vraies clés (disponibles dans `Settings` > `API` de votre projet Supabase).
    ```bash
    flutter run --dart-define=SUPABASE_URL=VOTRE_URL_SUPABASE --dart-define=SUPABASE_ANON_KEY=VOTRE_CLE_ANON
    ```

### Étape 4 : Déploiement

1.  **Android (Google Play Store) :**
    ```bash
    flutter build appbundle
    ```
    Le fichier à uploader se trouvera dans `build/app/outputs/bundle/release/`.

2.  **Web (PWA) :**
    ```bash
    flutter build web
    ```
    Uploadez le contenu du dossier `build/web` sur un service d'hébergement comme Netlify, Vercel ou Firebase Hosting.

---

Ce projet est maintenant une base solide et complète. En suivant ces instructions, vous pourrez le rendre entièrement opérationnel.