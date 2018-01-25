/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : ProductCategoryConfig.aspx.cs
*    Created By             : Fei Xue
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : 
*
----------------------------------------------------------------*/

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using ezMESWeb;
namespace ezMESWeb
{
    public partial class ProductCategoryConfig : System.Web.UI.Page
    {
       //protected SqlDataSource product_group_data;
        //int nStateSelect = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
        //    product_group_data = new SqlDataSource();
            //product_group_data.ProviderName = "MySql.Data.MySqlClient";
            //product_group_data.ConnectionString = "server=localhost;user id=root;Password=root;persist security info=True;database=ezmes";
            //product_group_data.InsertCommand = "INSERT INTO `product_group`(state, name, version, prefix, surfix, create_time,  created_by,  description, comment) VALUES ('production', @name, 1,@prefix, @surfix, now(),  1, NULL, NULL)";
            //product_group_data.SelectCommand = "SELECT p.id,p. name, p.prefix, p.surfix, p.create_time, concat(e.firstname, e.lastname) as created_by, p.description, p.comment  FROM `product_group` p, employee e";

        }
        protected void InsertButton_Click(object sender, EventArgs e)
        {

        }

        protected void FormView1_PageIndexChanging(object sender, FormViewPageEventArgs e)
        {

        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
