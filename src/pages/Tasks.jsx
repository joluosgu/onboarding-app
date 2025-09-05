
import React, { useEffect, useState } from 'react';
import { supabase } from '../services/supabaseClient';

function Tasks({ user }) {
  const [tasks, setTasks] = useState([]);

  useEffect(() => {
    const fetchTasks = async () => {
      const { data } = await supabase
        .from('tasks')
        .select('*')
        .eq('user_id', user.id);
      setTasks(data);
    };
    fetchTasks();
  }, [user]);

  const markCompleted = async (taskId) => {
    await supabase
      .from('tasks')
      .update({ completed: true })
      .eq('id', taskId);
    setTasks(tasks.map(t => t.id === taskId ? { ...t, completed: true } : t));
  };

  return (
    <div>
      <h2>Tareas asignadas</h2>
      <ul>
        {tasks.map(task => (
          <li key={task.id}>
            <a href={task.link} target="_blank" rel="noreferrer">{task.title}</a>
            {!task.completed && <button onClick={() => markCompleted(task.id)}>Marcar como completada</button>}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default Tasks;
