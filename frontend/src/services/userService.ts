import { ThreadsService } from "../api/services/ThreadsService";

class UserService {
  private cache: Record<string, string> = {};

  async initialize() {
    try {
      console.log('[UserService] Initializing user cache...');
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