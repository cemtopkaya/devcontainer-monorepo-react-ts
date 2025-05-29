// ...existing code...
// TypeScript tipi kaldırıldı
// CartItem tipi kaldırıldı, sadece fonksiyon kaldı
export function addItemToCart(cart, item) {
    return [...cart, item];
}
