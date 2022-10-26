export interface Items {
  name: string;
  label: string;
  image: string;
  price: number;
  stock: number;
}

export interface BennysItem extends Items {
  category: "Външен Тунинг" | "Вътрешен Тунинг" | "Други";
}

export interface DarkWebItems extends Items {
  category: "hacking" | "guns" | "drugs";
}

export interface BennysCartItems extends BennysItem {
  quantity: number;
}

export interface DarkWebCartItems extends DarkWebItems {
  quantity: number;
}
