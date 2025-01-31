import { ThreadsService } from '../api/services/ThreadsService';
import { UserMap } from '../api/models/UserMap';

let userCache: Record<string, string> = {};

export async function initUserCache() {
  try {
    const { users } = await ThreadsService.getUsers();
    userCache = Object.entries(users).reduce((acc, [userId, user]) => {
      const displayName = user.name || user.email || "Anonymous";
      console.log(`User ${userId}: ${displayName}`); // Log each user's name
      return {
        ...acc,
        [userId]: displayName
      };
    }, {});
    console.log('User cache initialized:', userCache); // Log the entire cache
  } catch (err) {
    console.error('Error initializing user cache:', err);
  }
}


// Get user name from cache
export function getUserName(userId: string): string {
  console.log('Looking up user ID:', userId); // Log the requested ID
  console.log('Current user cache:', userCache); // Log the entire cache
  return userCache[userId] || userId; // Return actual ID if not found
} 