import { useState } from 'react';
/** 
 * TypeScript sadece derleme sırasında CartItem tipini kullanır, 
 * Vite ise çalışma zamanında CartItem’ı aramaz ve hata oluşmaz.
 */ 
import type { CartItem } from 'cart-lib';
import { addItemToCart } from 'cart-lib';

import { Button } from 'ui-button';

function App() {
  const [cart, setCart] = useState<CartItem[]>([]);
  const handleAdd = () => {
    const item = { id: "1", name: "Elma", price: 5 };
    setCart(addItemToCart(cart, item));
  };

  return (
    <div>
      <h1>Sepet</h1>
      <Button onClick={handleAdd}>Elma Ekle</Button>
      <pre>{JSON.stringify(cart, null, 2)}</pre>
    </div>
  );
}

export default App;

