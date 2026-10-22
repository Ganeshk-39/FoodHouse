package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurant "
            + "(name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_RESTAURANT =
            "SELECT * FROM restaurant WHERE restaurantId = ?";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurant SET name=?, cuisineType=?, deliveryTime=?, "
            + "address=?, adminUserId=?, rating=?, isActive=?, imagePath=? "
            + "WHERE restaurantId=?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurant WHERE restaurantId = ?";

    private static final String SELECT_ALL_RESTAURANTS =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_RESTAURANT)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setInt(5, restaurant.getAdminUserId());
            ps.setDouble(6, restaurant.getRating());
            ps.setBoolean(7, restaurant.isActive());
            ps.setString(8, restaurant.getImagePath());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_RESTAURANT)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    restaurant = new Restaurant();

                    restaurant.setRestaurantId(rs.getInt("restaurantId"));
                    restaurant.setName(rs.getString("name"));
                    restaurant.setCuisineType(rs.getString("cuisineType"));
                    restaurant.setDeliveryTime(rs.getInt("deliveryTime"));
                    restaurant.setAddress(rs.getString("address"));
                    restaurant.setAdminUserId(rs.getInt("adminUserId"));
                    restaurant.setRating(rs.getDouble("rating"));
                    restaurant.setActive(rs.getBoolean("isActive"));
                    restaurant.setImagePath(rs.getString("imagePath"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_RESTAURANT)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setInt(5, restaurant.getAdminUserId());
            ps.setDouble(6, restaurant.getRating());
            ps.setBoolean(7, restaurant.isActive());
            ps.setString(8, restaurant.getImagePath());
            ps.setInt(9, restaurant.getRestaurantId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_RESTAURANT)) {

            ps.setInt(1, restaurantId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_ALL_RESTAURANTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Restaurant restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setName(rs.getString("name"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setDeliveryTime(rs.getInt("deliveryTime"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setAdminUserId(rs.getInt("adminUserId"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setActive(rs.getBoolean("isActive"));
                restaurant.setImagePath(rs.getString("imagePath"));

                restaurants.add(restaurant);
            }

            System.out.println("Total Restaurants Fetched: " + restaurants.size());

        } catch (SQLException e) {

            System.out.println("Error while fetching restaurants:");
            e.printStackTrace();
        }

        return restaurants;
    }
}