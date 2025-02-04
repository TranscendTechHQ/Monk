import { Component } from 'solid-js';
import { useNavigate } from '@solidjs/router';

const Header: Component = () => {
  const navigate = useNavigate();

  return (
    <header class="h-[70px] flex items-center px-6 bg-monk-dark border-b border-monk-teal/20">
      <div class="flex items-center gap-3">
        <img
          src="/svg/logo.svg"
          alt="Monk Chat Logo"
          class="h-14 w-14 cursor-pointer inline-block 
                 filter-monk-gold hover:filter-monk-gold-hover
                 transition-filter duration-200"
          onClick={() => navigate('/')}
        />
        <span class="text-monk-gold font-bold text-2xl font-mono">MONK</span>
      </div>
    </header>
  );
};

export default Header; 