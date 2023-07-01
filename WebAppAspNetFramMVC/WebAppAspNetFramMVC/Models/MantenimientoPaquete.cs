using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace WebAppAspNetFramMVC.Models
{
    public class MantenimientoPaquete
    {
        private SqlConnection conexion;

        private void Conectar() 
        {
            // Con la etiqueta connectionStrings
            string cadenaConexion = //Sin cifrar: ConnectionStrings["name"] 
                ConfigurationManager.ConnectionStrings["administracion"].ToString();
            // Cifrado: ConnectionStrings["name"], es decir, es el mismo argumento.
            // Pero, hay que tener precauci-on al abrir Visual Studio Tools con el
            // mismo usuario que se cifr-o o encript-o la cadena de conexi-on.

            
            // Con la etiqueta appSettings
            //string cadenaConexion = WebConfigurationManager.AppSettings["SQLCONN"].ToString();
            
            //------------------------------------------------------------
            conexion = new SqlConnection(cadenaConexion);
        }

        public List<Paquete> RecuperarTodos() 
        {
            Conectar();
            List<Paquete> paquetes = new List<Paquete>();
            SqlCommand comm = new SqlCommand("SELECT * FROM PAQUETE", conexion);
            conexion.Open();
            SqlDataReader registros = comm.ExecuteReader();
            while (registros.Read()) 
            {
                Paquete paq = new Paquete
                {
                    Cod_paquete = registros["COD_PAQUETE"].ToString(),
                    Descripcion = registros["DESCRIPCION"].ToString(),
                    Destinatario = registros["DESTINATARIO"].ToString(),
                    Direccion_destinatario = registros["DIRECCION_DESTINATARIO"].ToString(),
                    Cedula_conductor = registros["CEDULA_CONDUCTOR"].ToString(),
                    Provincia_destino = registros["PROVINCIA_DESTINO"].ToString()

                };
                paquetes.Add(paq);
            }
            conexion.Close();
            return paquetes;
        }
    }
}