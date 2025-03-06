import { Component, createSignal, onMount, Show, For, createEffect } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import * as Session from "supertokens-web-js/recipe/session";
import { useUser } from '../context/UserContext';
import Header from '../components/Header';
import Footer from '../components/Footer';
import { AdminService } from '../api/services/AdminService';
import type { UserInfo } from '../api/models/UserInfo';
import type { TenantInfo } from '../api/models/TenantInfo';

// Use the generated API types instead of custom interfaces
type User = UserInfo;
type Tenant = TenantInfo;

const AdminDashboard: Component = () => {
  const [users, setUsers] = createSignal<User[]>([]);
  const [tenants, setTenants] = createSignal<Tenant[]>([]);
  const [loading, setLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [activeTab, setActiveTab] = createSignal<'users' | 'tenants'>('users');
  const [selectedUser, setSelectedUser] = createSignal<User | null>(null);
  const [selectedTenant, setSelectedTenant] = createSignal<Tenant | null>(null);
  const [showUserDetails, setShowUserDetails] = createSignal(false);
  const [showTenantDetails, setShowTenantDetails] = createSignal(false);
  
  const navigate = useNavigate();
  const userContext = useUser();

  onMount(async () => {
    // Check if user is logged in
    const sessionExists = await Session.doesSessionExist();
    if (!sessionExists) {
      navigate('/login');
      return;
    }

    // Check if user is an admin (you might want to implement proper admin checks)
    // For now, we'll just proceed with fetching data
    fetchUsers();
    fetchTenants();
  });

  createEffect(() => {
    if (selectedUser()) {
      setShowUserDetails(true);
    }
  });

  createEffect(() => {
    if (selectedTenant()) {
      setShowTenantDetails(true);
    }
  });

  const fetchUsers = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const data = await AdminService.getAllUsers();
      setUsers(data.users);
    } catch (err: any) {
      console.error("Error fetching users:", err);
      setError(err.message || "Failed to load users");
    } finally {
      setLoading(false);
    }
  };

  const fetchTenants = async () => {
    try {
      const data = await AdminService.getAllTenants();
      setTenants(data.tenants);
    } catch (err: any) {
      console.error("Error fetching tenants:", err);
      setError(err.message || "Failed to load tenants");
    }
  };

  const formatDate = (timestamp: number | null | undefined) => {
    if (timestamp === undefined || timestamp === null) {
      return '-';
    }
    return new Date(timestamp).toLocaleString();
  };

  const viewUserDetails = (user: User) => {
    setSelectedUser(user);
    setShowUserDetails(true);
  };

  const viewTenantDetails = (tenant: Tenant) => {
    setSelectedTenant(tenant);
    setShowTenantDetails(true);
  };

  const closeUserDetails = () => {
    setShowUserDetails(false);
    setSelectedUser(null);
  };

  const closeTenantDetails = () => {
    setShowTenantDetails(false);
    setSelectedTenant(null);
  };

  return (
    <div class="h-screen flex flex-col bg-slate-900 text-white">
      <Header />
      
      <div class="flex-1 overflow-y-auto p-4">
        <div class="max-w-7xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">SuperTokens Admin Dashboard</h1>
          
          {/* Tabs */}
          <div class="flex border-b border-slate-700 mb-6">
            <button 
              class={`px-4 py-2 font-medium ${activeTab() === 'users' ? 'text-blue-400 border-b-2 border-blue-400' : 'text-slate-400 hover:text-slate-300'}`}
              onClick={() => setActiveTab('users')}
            >
              Users
            </button>
            <button 
              class={`px-4 py-2 font-medium ${activeTab() === 'tenants' ? 'text-blue-400 border-b-2 border-blue-400' : 'text-slate-400 hover:text-slate-300'}`}
              onClick={() => setActiveTab('tenants')}
            >
              Tenants
            </button>
          </div>
          
          <Show when={error()}>
            <div class="bg-red-900/50 border border-red-500 text-red-200 px-4 py-3 rounded mb-4">
              <p>{error()}</p>
              <button 
                onClick={fetchUsers}
                class="mt-2 bg-red-700 hover:bg-red-600 text-white px-3 py-1 rounded text-sm"
              >
                Try Again
              </button>
            </div>
          </Show>
          
          {/* Users Tab */}
          <Show when={activeTab() === 'users'}>
            <div class="bg-slate-800 rounded-lg shadow-lg p-6 mb-6">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-semibold">User Management</h2>
                <button 
                  onClick={fetchUsers}
                  class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm"
                >
                  Refresh
                </button>
              </div>
              
              <Show when={loading()} fallback={
                <div class="overflow-x-auto">
                  <table class="min-w-full bg-slate-700 rounded-lg overflow-hidden">
                    <thead class="bg-slate-600">
                      <tr>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">ID</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Email</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Name</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Joined</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Tenants</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Actions</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-600">
                      <Show when={users().length > 0} fallback={
                        <tr>
                          <td colspan="6" class="px-4 py-6 text-center text-slate-400">
                            No users found
                          </td>
                        </tr>
                      }>
                        <For each={users()}>
                          {(user) => (
                            <tr class="hover:bg-slate-600/50">
                              <td class="px-4 py-3 text-sm text-slate-300 font-mono">{user.id.substring(0, 8)}...</td>
                              <td class="px-4 py-3 text-sm text-slate-300">{user.email}</td>
                              <td class="px-4 py-3 text-sm text-slate-300">{user.name || '-'}</td>
                              <td class="px-4 py-3 text-sm text-slate-300">{formatDate(user.timeJoined)}</td>
                              <td class="px-4 py-3 text-sm text-slate-300">
                                {user.tenantIds?.length ? user.tenantIds.join(', ') : '-'}
                              </td>
                              <td class="px-4 py-3 text-sm">
                                <button 
                                  onClick={() => viewUserDetails(user)}
                                  class="text-blue-400 hover:text-blue-300"
                                >
                                  View Details
                                </button>
                              </td>
                            </tr>
                          )}
                        </For>
                      </Show>
                    </tbody>
                  </table>
                </div>
              }>
                <div class="flex justify-center items-center py-12">
                  <svg class="animate-spin h-8 w-8 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  <span class="ml-3 text-slate-300">Loading users...</span>
                </div>
              </Show>
            </div>
          </Show>
          
          {/* Tenants Tab */}
          <Show when={activeTab() === 'tenants'}>
            <div class="bg-slate-800 rounded-lg shadow-lg p-6 mb-6">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-semibold">Tenant Management</h2>
                <button 
                  onClick={fetchTenants}
                  class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm"
                >
                  Refresh
                </button>
              </div>
              
              <Show when={loading()} fallback={
                <div class="overflow-x-auto">
                  <table class="min-w-full bg-slate-700 rounded-lg overflow-hidden">
                    <thead class="bg-slate-600">
                      <tr>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Tenant ID</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Name</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">User Count</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Created</th>
                        <th class="px-4 py-3 text-left text-sm font-medium text-slate-300">Actions</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-600">
                      <Show when={tenants().length > 0} fallback={
                        <tr>
                          <td colspan="5" class="px-4 py-6 text-center text-slate-400">
                            No tenants found
                          </td>
                        </tr>
                      }>
                        <For each={tenants()}>
                          {(tenant) => (
                            <tr class="hover:bg-slate-600/50">
                              <td class="px-4 py-3 text-sm text-slate-300">{tenant.tenantId}</td>
                              <td class="px-4 py-3 text-sm text-slate-300">{tenant.name}</td>
                              <td class="px-4 py-3 text-sm text-slate-300">{tenant.userCount || 0}</td>
                              <td class="px-4 py-3 text-sm text-slate-300">
                                {tenant.createdAt ? formatDate(tenant.createdAt) : '-'}
                              </td>
                              <td class="px-4 py-3 text-sm">
                                <button 
                                  onClick={() => viewTenantDetails(tenant)}
                                  class="text-blue-400 hover:text-blue-300"
                                >
                                  View Details
                                </button>
                              </td>
                            </tr>
                          )}
                        </For>
                      </Show>
                    </tbody>
                  </table>
                </div>
              }>
                <div class="flex justify-center items-center py-12">
                  <svg class="animate-spin h-8 w-8 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  <span class="ml-3 text-slate-300">Loading tenants...</span>
                </div>
              </Show>
            </div>
          </Show>
        </div>
      </div>
      
      {/* User Details Modal */}
      <Show when={showUserDetails() && selectedUser()}>
        <div class="fixed inset-0 bg-black/70 flex items-center justify-center p-4 z-50">
          <div class="bg-slate-800 rounded-lg shadow-xl max-w-2xl w-full max-h-[80vh] overflow-y-auto">
            <div class="p-6">
              <div class="flex justify-between items-start mb-4">
                <h2 class="text-xl font-semibold">User Details</h2>
                <button 
                  onClick={closeUserDetails}
                  class="text-slate-400 hover:text-white"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              <div class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <p class="text-sm text-slate-400">User ID</p>
                    <p class="font-mono text-sm break-all">{selectedUser()!.id}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Email</p>
                    <p>{selectedUser()!.email}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Name</p>
                    <p>{selectedUser()!.name || '-'}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Joined</p>
                    <p>{formatDate(selectedUser()!.timeJoined)}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Email Verified</p>
                    <p>{selectedUser()!.verified ? 'Yes' : 'No'}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Login Methods</p>
                    <p>{selectedUser()!.loginMethods?.join(', ') || 'Email/Password'}</p>
                  </div>
                </div>
                
                <div>
                  <p class="text-sm text-slate-400 mb-2">Tenant Memberships</p>
                  <Show when={selectedUser()!.tenantIds?.length} fallback={
                    <p class="text-sm text-slate-500">User is not a member of any tenants</p>
                  }>
                    <div class="bg-slate-700 rounded p-3">
                      <For each={selectedUser()!.tenantIds}>
                        {(tenantId) => (
                          <div class="flex items-center justify-between py-1">
                            <span class="text-sm">{tenantId}</span>
                            <button class="text-xs text-red-400 hover:text-red-300">
                              Remove
                            </button>
                          </div>
                        )}
                      </For>
                    </div>
                  </Show>
                </div>
                
                <div class="border-t border-slate-700 pt-4 flex justify-between">
                  <div>
                    <button class="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-sm">
                      Delete User
                    </button>
                  </div>
                  <div>
                    <button class="bg-slate-700 hover:bg-slate-600 text-white px-3 py-1 rounded text-sm mr-2">
                      Reset Password
                    </button>
                    <button class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm">
                      Add to Tenant
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Show>
      
      {/* Tenant Details Modal */}
      <Show when={showTenantDetails() && selectedTenant()}>
        <div class="fixed inset-0 bg-black/70 flex items-center justify-center p-4 z-50">
          <div class="bg-slate-800 rounded-lg shadow-xl max-w-2xl w-full max-h-[80vh] overflow-y-auto">
            <div class="p-6">
              <div class="flex justify-between items-start mb-4">
                <h2 class="text-xl font-semibold">Tenant Details</h2>
                <button 
                  onClick={closeTenantDetails}
                  class="text-slate-400 hover:text-white"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              <div class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <p class="text-sm text-slate-400">Tenant ID</p>
                    <p class="font-mono text-sm">{selectedTenant()!.tenantId}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Name</p>
                    <p>{selectedTenant()!.name}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">User Count</p>
                    <p>{selectedTenant()!.userCount || 0}</p>
                  </div>
                  <div>
                    <p class="text-sm text-slate-400">Created</p>
                    <p>{selectedTenant()!.createdAt ? formatDate(selectedTenant()!.createdAt) : '-'}</p>
                  </div>
                </div>
                
                <div class="border-t border-slate-700 pt-4 flex justify-between">
                  <div>
                    <button class="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-sm">
                      Delete Tenant
                    </button>
                  </div>
                  <div>
                    <button class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm">
                      Add User
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Show>
      
      <Footer />
    </div>
  );
};

export default AdminDashboard; 