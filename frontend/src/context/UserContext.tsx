import { createContext, useContext, createSignal, JSX, onMount } from 'solid-js';
import { SessionService } from '../api/services/SessionService'; // Import the SessionService
import Session from 'supertokens-web-js/recipe/session';

// Define the User type
interface User {
  name: string;
  email: string;
}

// Define the context type
interface UserContextType {
  user: () => User | null; // Allow user to be null
  setUser: (user: User | null) => void; // Allow setting user to null
  refreshUser: () => Promise<void>; // Add refreshUser function
}

const UserContext = createContext<UserContextType>();

export const UserProvider = (props: { children: JSX.Element }) => {
  const [user, setUser] = createSignal<User | null>(null); // Initialize user as null

  // Function to fetch user data
  const refreshUser = async () => {
    try {
      // Check if session exists before trying to fetch user data
      const sessionExists = await Session.doesSessionExist();
      if (!sessionExists) {
        console.log('No session exists, skipping user data fetch');
        setUser(null);
        return;
      }
      
      console.log('Fetching user data...');
      const sessionData = await SessionService.secureApiSessioninfoGet();
      const userData: User = { name: sessionData.fullName, email: sessionData.email }; // Create a user object
      console.log('User data fetched successfully:', userData);
      setUser(userData); // Set the user data
    } catch (error) {
      console.error('Failed to fetch user data:', error);
      // Don't set user to null here to avoid flickering if there's a temporary error
    }
  };

  // Fetch user data on mount
  onMount(() => {
    refreshUser();
  });

  return (
    <UserContext.Provider value={{ user, setUser, refreshUser }}>
      {props.children}
    </UserContext.Provider>
  );
};

export const useUser = () => {
  return useContext(UserContext);
}; 