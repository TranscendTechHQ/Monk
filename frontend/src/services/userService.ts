import { ThreadsService } from "../api/services/ThreadsService";
import Session from "supertokens-web-js/recipe/session";

class UserService {
  private cache: Record<string, string> = {};

  async initialize() {
    try {
      console.log('[UserService] Checking session before initializing user cache...');
      
      // Check if user is authenticated before making the API call
      const sessionExists = await Session.doesSessionExist();
      if (!sessionExists) {
        console.log('[UserService] No active session found, skipping initialization');
        return;
      }
      
      console.log('[UserService] Session exists, initializing user cache...');
      const response = await ThreadsService.getUsers();
      
      this.cache = response.users.reduce((acc, user) => {
        const displayName = user.name || user.email || "Anonymous";
        //console.log(displayName);
        return { ...acc, [user._id]: displayName };
      }, {});
      
      //console.log('[UserService] Cache initialized with', Object.keys(this.cache).length, 'users');
    } catch (error) {
      console.error('[UserService] Initialization error:', error);
    }
  }

  getUserName(userId: string) {
    return this.cache[userId] || userId;
  }
}

export const userService = new UserService(); 