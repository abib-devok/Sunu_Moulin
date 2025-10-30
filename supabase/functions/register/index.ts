import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.44.2'
import * as bcrypt from "https://deno.land/x/bcrypt@v0.4.1/mod.ts";

// Entête pour gérer les requêtes cross-origin (CORS)
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Gère la requête pre-flight (CORS)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Récupère les données de la requête
    const { username, password } = await req.json()
    if (!username || !password) {
      throw new Error("Nom d'utilisateur ou mot de passe manquant.");
    }

    // Valide la longueur du mot de passe
    if (password.length < 6) {
      throw new Error("Le mot de passe doit contenir au moins 6 caractères.");
    }

    // Crée un client Supabase avec le rôle `service_role` pour avoir les pleins pouvoirs
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Vérifie si l'utilisateur existe déjà
    const { data: existingUser, error: findError } = await supabaseAdmin
      .from('users')
      .select('id')
      .eq('username', username)
      .single();

    if (findError && findError.code !== 'PGRST116') { // PGRST116 = 'not found'
        throw findError;
    }

    if (existingUser) {
      return new Response(JSON.stringify({ error: "Ce nom d'utilisateur est déjà pris." }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 409, // Conflict
      })
    }

    // Hache le mot de passe
    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(password, salt);

    // Insère le nouvel utilisateur
    const { error: insertError } = await supabaseAdmin
      .from('users')
      .insert({ username, password_hash });

    if (insertError) {
      throw insertError;
    }

    // Retourne une réponse de succès
    return new Response(JSON.stringify({ message: 'Utilisateur créé avec succès.' }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 201, // Created
    })

  } catch (error) {
    // Gère les erreurs
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})