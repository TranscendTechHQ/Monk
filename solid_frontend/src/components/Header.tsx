import { Component } from 'solid-js';
import { useNavigate } from '@solidjs/router';

const Header: Component = () => {
  const navigate = useNavigate();

  return (
    <header class="h-[70px] flex items-center px-6 bg-monk-dark border-b border-monk-teal/20">
      <div class="flex items-center gap-4">
        <img
          src="/images/logo.png"
          alt="Monk Chat Logo"
          class="h-12 w-12 cursor-pointer hover:opacity-80 transition-opacity"
          onClick={() => navigate('/')}
        />
        <span class="text-monk-gold font-bold text-xl">MONK</span>
      </div>
    </header>
  );
};

export default Header; 