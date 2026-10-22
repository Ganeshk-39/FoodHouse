package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT_MENU =
            "INSERT INTO menu "
            + "(restaurantId, itemName, description, price, isAvailable, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_MENU =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurantId = ?, itemName = ?, description = ?, "
            + "price = ?, isAvailable = ?, imagePath = ? "
            + "WHERE menuId = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menuId = ?";

    private static final String GET_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String GET_MENU_BY_RESTAURANT_ID =
            "SELECT * FROM menu WHERE restaurantId = ?";


    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(INSERT_MENU)) {

            statement.setInt(1, menu.getRestaurantId());
            statement.setString(2, menu.getItemName());
            statement.setString(3, menu.getDescription());
            statement.setDouble(4, menu.getPrice());
            statement.setBoolean(5, menu.isAvailable());
            statement.setString(6, menu.getImagePath());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(GET_MENU)) {

            statement.setInt(1, menuId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {

                menu = new Menu();

                menu.setMenuId(resultSet.getInt("menuId"));
                menu.setRestaurantId(resultSet.getInt("restaurantId"));
                menu.setItemName(resultSet.getString("itemName"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setAvailable(resultSet.getBoolean("isAvailable"));
                menu.setImagePath(resultSet.getString("imagePath"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }


    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_MENU)) {

            statement.setInt(1, menu.getRestaurantId());
            statement.setString(2, menu.getItemName());
            statement.setString(3, menu.getDescription());
            statement.setDouble(4, menu.getPrice());
            statement.setBoolean(5, menu.isAvailable());
            statement.setString(6, menu.getImagePath());
            statement.setInt(7, menu.getMenuId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_MENU)) {

            statement.setInt(1, menuId);

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(GET_ALL_MENUS)) {

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                Menu menu = new Menu();

                menu.setMenuId(resultSet.getInt("menuId"));
                menu.setRestaurantId(resultSet.getInt("restaurantId"));
                menu.setItemName(resultSet.getString("itemName"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setAvailable(resultSet.getBoolean("isAvailable"));
                menu.setImagePath(resultSet.getString("imagePath"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(GET_MENU_BY_RESTAURANT_ID)) {

            statement.setInt(1, restaurantId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                Menu menu = new Menu();

                menu.setMenuId(resultSet.getInt("menuId"));
                menu.setRestaurantId(resultSet.getInt("restaurantId"));
                menu.setItemName(resultSet.getString("itemName"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setAvailable(resultSet.getBoolean("isAvailable"));
                menu.setImagePath(resultSet.getString("imagePath"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }
}