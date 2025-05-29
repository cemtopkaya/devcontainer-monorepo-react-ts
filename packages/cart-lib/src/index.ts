export type CartItem = {
    id: string;
    name: string;
    price: number;
};

export function addItemToCart(cart: CartItem[], item: CartItem): CartItem[] {
    return [...cart, item];
}
