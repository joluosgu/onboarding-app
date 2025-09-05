
import React, { useState } from 'react';
import { supabase } from '../services/supabaseClient';

function Login({ setUser }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async () => {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .eq('email', email)
      .eq('password', password)
      .single();

    if (data) setUser(data);
    else alert('Credenciales incorrectas');
  };

  return (
    <div>
      <h2>Iniciar sesión</h2>
      <input placeholder="Email" onChange={e => setEmail(e.target.value)} />
      <input placeholder="Contraseña" type="password" onChange={e => setPassword(e.target.value)} />
      <button onClick={handleLogin}>Entrar</button>
    </div>
  );
}

export default Login;
