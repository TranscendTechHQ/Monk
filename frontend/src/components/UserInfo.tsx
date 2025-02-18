import { Component } from 'solid-js';
import { useUser } from '../context/UserContext';

const UserInfo: Component = () => {
  const userContext = useUser();

  // Assert that userContext is defined
  if (!userContext) {
    return null; // or handle the case where context is not available
  }

  const { user } = userContext;

  return (
    <div class="bg-monk-light p-4 rounded-lg shadow-monk">
      {user() ? ( // Check if user data is available
        <>
          <p>{user()?.name}</p>
          <p>{user()?.email}</p>
        </>
      ) : (
        <p>Loading user info...</p> // Show loading state if user data is not yet available
      )}
    </div>
  );
};

export default UserInfo; 