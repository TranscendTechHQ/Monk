import { ThreadsService } from "../api/services/ThreadsService";

class UserService {
  private cache: Record<string, string> = {};

  async initialize() {
    try {
      console.log('[UserService] Starting user cache initialization...');
      const response = await ThreadsService.getUsers();
      console.log('[UserService] API response:', response);
      
      this.cache = Object.entries(response.users).reduce((acc, [userId, user]) => {
        const displayName = user.name || user.email || "Anonymous";
        console.log(`[Cache] Storing user ${userId}: ${displayName}`);
        return { ...acc, [userId]: displayName };
      }, {});
      
      console.log('[UserService] Cache initialization completed with', Object.keys(this.cache).length, 'users');
    } catch (error) {
      console.error('[UserService] Initialization error:', error);
    }
  }

  getUserName(userId: string) {
    return this.cache[userId] || userId;
  }
}

export const userService = new UserService(); 