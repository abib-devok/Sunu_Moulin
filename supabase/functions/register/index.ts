import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.44.2'
// Utilisation d'une librairie de hachage compatible avec Deno Edge Functions
import { hash, genSalt } from "https://deno.land/x/bcryptjs@v2.4.3/mod.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { username, password } = await req.json()
    if (!username || !password) {
      throw new Error("Nom d'utilisateur ou mot de passe manquant.");
    }

    if (password.length < 6) {
      throw new Error("Le mot de passe doit contenir au moins 6 caractères.");
    }

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { data: existingUser, error: findError } = await supabaseAdmin
      .from('users')
      .select('id')
      .eq('username', username)
      .single();

    if (findError && findError.code !== 'PGRST116') {
        throw findError;
    }

    if (existingUser) {
      return new Response(JSON.stringify({ error: "Ce nom d'utilisateur est déjà pris." }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 409,
      })
    }

    const salt = await genSalt(10);
    const password_hash = await hash(password, salt);

    const { error: insertError } = await supabaseAdmin
      .from('users')
      .insert({ username, password_hash });

    if (insertError) {
      throw insertError;
    }

    return new Response(JSON.stringify({ message: 'Utilisateur créé avec succès.' }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 201,
    })

  } catch (error) {
    return new Response(JSON.stringify({ error: `Erreur interne (register): ${error.message}` }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 500,
    })
  }
})