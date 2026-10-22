package com.tap.model;

public class CartItem {

    private int itemId;
    private int restaurantId;
    private String name;
    private int quantity;
    private double price;
    private Menu menu;

    public CartItem() {
    }

    public CartItem(Menu menu, int quantity) {
        this.menu = menu;
        this.quantity = quantity;
        if (menu != null) {
            this.itemId = menu.getMenuId();
            this.restaurantId = menu.getRestaurantId();
            this.name = menu.getName();
            this.price = menu.getPrice();
        }
    }

    public CartItem(int itemId, int restaurantId, String name, int quantity, double price) {
        this.itemId = itemId;
        this.restaurantId = restaurantId;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
    }

    public Menu getMenu() {
        return menu;
    }

    public void setMenu(Menu menu) {
        this.menu = menu;
        if (menu != null) {
            this.itemId = menu.getMenuId();
            this.restaurantId = menu.getRestaurantId();
            this.name = menu.getName();
            this.price = menu.getPrice();
        }
    }

    public int getItemId() {
        if (itemId > 0) return itemId;
        return menu != null ? menu.getMenuId() : 0;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getMenuId() {
        return getItemId();
    }

    public void setMenuId(int menuId) {
        this.itemId = menuId;
    }

    public int getRestaurantId() {
        if (restaurantId > 0) return restaurantId;
        return menu != null ? menu.getRestaurantId() : 0;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        if (name != null && !name.isEmpty()) return name;
        return menu != null ? menu.getName() : "";
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        if (price > 0) return price;
        return menu != null ? menu.getPrice() : 0.0;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getSubtotal() {
        double p = getPrice();
        return p * quantity;
    }

    public double getTotalPrice() {
        return getSubtotal();
    }

    @Override
    public String toString() {
        return "CartItem [itemId=" + getItemId()
                + ", name=" + getName()
                + ", quantity=" + quantity
                + ", price=" + getPrice()
                + ", subtotal=" + getSubtotal() + "]";
    }
}
