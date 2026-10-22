package com.tap.model;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Represents the Shopping Cart stored in the user's HttpSession.
 * Holds the restaurantId (single-restaurant restriction) and 
 * a Map of menuId -> CartItem maintaining insertion order.
 */
public class Cart {

    private int restaurantId;
    private Map<Integer, CartItem> items;

    public Cart() {
        this.restaurantId = 0;
        this.items = new LinkedHashMap<>();
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    /**
     * Adds a Menu item to the cart.
     * Enforces single-restaurant ordering rule.
     * @param menu The Menu item to add
     * @return true if added successfully, false if from different restaurant
     */
    public boolean addItem(Menu menu) {
        return addItem(menu, 1);
    }

    /**
     * Adds a Menu item with a specific quantity to the cart.
     */
    public boolean addItem(Menu menu, int quantity) {
        if (menu == null) {
            return false;
        }

        // If cart is empty, lock cart to this restaurant
        if (items.isEmpty()) {
            this.restaurantId = menu.getRestaurantId();
        }

        // Check if item belongs to the same restaurant
        if (this.restaurantId != menu.getRestaurantId()) {
            return false;
        }

        int menuId = menu.getMenuId();
        if (items.containsKey(menuId)) {
            CartItem existingItem = items.get(menuId);
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(menu, quantity);
            items.put(menuId, newItem);
        }

        return true;
    }

    /**
     * Adds a CartItem directly.
     */
    public boolean addItem(CartItem item) {
        if (item == null || item.getMenu() == null) {
            return false;
        }
        return addItem(item.getMenu(), item.getQuantity());
    }

    /**
     * Updates the quantity of a specific item in the cart.
     */
    public void updateItem(int itemId, int quantity) {
        if (items.containsKey(itemId)) {
            if (quantity <= 0) {
                items.remove(itemId);
                if (items.isEmpty()) {
                    this.restaurantId = 0;
                }
            } else {
                CartItem existingItem = items.get(itemId);
                existingItem.setQuantity(quantity);
            }
        }
    }

    public void updateQuantity(int itemId, int quantity) {
        updateItem(itemId, quantity);
    }

    /**
     * Removes an item completely from the cart.
     */
    public void deleteItem(int itemId) {
        items.remove(itemId);
        if (items.isEmpty()) {
            this.restaurantId = 0;
        }
    }

    public void removeItem(int itemId) {
        deleteItem(itemId);
    }

    /**
     * Clears all items from the cart and resets restaurantId.
     */
    public void clear() {
        items.clear();
        this.restaurantId = 0;
    }

    /**
     * Calculates the total price of all items in the cart.
     */
    public double getTotalPrice() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            total += item.getSubtotal();
        }
        return total;
    }

    public double getTotal() {
        return getTotalPrice();
    }

    public double getTotalAmount() {
        return getTotalPrice();
    }
}

