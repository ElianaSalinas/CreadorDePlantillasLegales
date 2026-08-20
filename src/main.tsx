// Defensive safeguard for environments where window.fetch has only a getter
try {
  if (typeof window !== 'undefined' && window.fetch) {
    let _fetchRef = window.fetch.bind(window);
    try {
      Object.defineProperty(window, 'fetch', {
        get: () => _fetchRef,
        set: (fn) => {
          _fetchRef = fn;
        },
        configurable: true,
        enumerable: true,
      });
    } catch {}
  }
} catch {}

import {StrictMode} from 'react';
import {createRoot} from 'react-dom/client';
import App from './App.tsx';
import './index.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);

