
import React, { useState } from 'react';
import Login from './pages/Login';
import Tasks from './pages/Tasks';

function App() {
  const [user, setUser] = useState(null);

  return (
    <div>
      <h1>Bienvenido al equipo</h1>
      {!user ? <Login setUser={setUser} /> : <Tasks user={user} />}
    </div>
  );
}

export default App;
