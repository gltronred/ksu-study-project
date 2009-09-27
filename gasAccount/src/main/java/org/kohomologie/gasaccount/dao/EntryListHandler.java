/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.kohomologie.gasaccount.dao;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.commons.dbutils.handlers.AbstractListHandler;
import org.kohomologie.gasaccount.entity.Entry;
/**
 *
 * @author antechrome
 */
public class EntryListHandler extends AbstractListHandler {

    @Override
    protected Entry handleRow (ResultSet rs) throws SQLException {
    return new Entry()
            .fixDate(rs.getDate(Entry.fixDateColumnName))
            .fuelBrand(rs.getString(Entry.fuelBrandColumnName))
            .mileage(rs.getInt(Entry.mileageColumnName))
            .numberOfGallons(rs.getFloat(Entry.numberOfGallonsColumnName))
            .priceOfAGallon(rs.getFloat(Entry.priceOfAGallonColumnName));
          }
    }
