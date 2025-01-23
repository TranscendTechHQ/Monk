import { createContext, useContext, createSignal, JSX, onMount } from 'solid-js';
import { SessionService } from '../api/services/SessionService'; // Import the SessionService

// Define the User type
interface User {
  name: string;
  email: string;
}

// Define the context type
interface UserContextType {
  user: () => User | null; // Allow user to be null
  setUser: (user: User) => void;
}

const UserContext = createContext<UserContextType>();

export const UserProvider = (props: { children: JSX.Element }) => {
  const [user, setUser] = createSignal<User | null>(null); // Initialize user as null

  // Fetch user data on mount
  onMount(async () => {
    try {
      const sessionData = await SessionService.secureApiSessioninfoGet();
      const userData: User = { name: sessionData.fullName, email: sessionData.email }; // Create a user object
      setUser(userData); // Set the user data
    } catch (error) {
      console.error('Failed to fetch user data:', error);
    }
  });

  return (
    <UserContext.Provider value={{ user, setUser }}>
      {props.children}
    </UserContext.Provider>
  );
};

export const useUser = () => {
  return useContext(UserContext);
}; 