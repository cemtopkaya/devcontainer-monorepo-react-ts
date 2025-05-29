import { useState } from 'react';
import { addItemToCart } from 'cart-lib';
import { Button } from 'ui-button';

function App() {
  const [cart, setCart] = useState([]);
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
