import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.44.2'
import * as bcrypt from "https://deno.land/x/bcrypt@v0.4.1/mod.ts";
import { create } from "https://deno.land/x/djwt@v3.0.2/mod.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// Fonction pour générer un token JWT
async function generateJWT(userId: string, userRole: string, secret: string) {
    const key = await crypto.subtle.importKey(
        "raw",
        new TextEncoder().encode(secret),
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["sign", "verify"]
    );

    return await create({ alg: "HS256", typ: "JWT" }, {
        sub: userId,
        role: userRole,
        exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 7) // Expire dans 7 jours
    }, key);
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

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Trouve l'utilisateur
    const { data: user, error: findError } = await supabaseAdmin
      .from('users')
      .select('id, password_hash')
      .eq('username', username)
      .single();

    if (findError || !user) {
      throw new Error("Identifiants incorrects.");
    }

    // Vérifie le mot de passe
    const passwordMatch = await bcrypt.compare(password, user.password_hash);
    if (!passwordMatch) {
      throw new Error("Identifiants incorrects.");
    }

    // Génère le token JWT
    const jwtSecret = Deno.env.get('SUPABASE_JWT_SECRET');
    if (!jwtSecret) {
        throw new Error("La clé secrète JWT n'est pas configurée.");
    }

    const token = await generateJWT(user.id, 'authenticated', jwtSecret);

    // Retourne le token
    return new Response(JSON.stringify({
        message: 'Connexion réussie.',
        token: token,
        user: { id: user.id, username: username }
    }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})