export type CartItem = {
    id: string;
    name: string;
    price: number;
};
export declare function addItemToCart(cart: CartItem[], item: CartItem): CartItem[];
