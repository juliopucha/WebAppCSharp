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

        //-------------acceso a datos con nombre de SP existente en una BDD de SQL Server

        public List<ConductorCamion> conductoresConducenCamionesPorPlaca(string placa)
        {
            Conectar();
            List<ConductorCamion> lista = new List<ConductorCamion>();

            try
            {
                SqlCommand comando = new SqlCommand("pa_conductor_conduce_camion_por_placa", conexion);
                conexion.Open();
                comando.CommandType = System.Data.CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@placacamion", placa);
                SqlDataReader reader = comando.ExecuteReader();
                while (reader.Read())
                {
                    ConductorCamion cc = new ConductorCamion();
                    cc.Cedula_conductor = reader.GetString(0);
                    cc.Nombre_conductor = reader.GetString(1);
                    cc.Placa = reader.GetString(2);
                    cc.Modelo = reader.GetString(3);
                    cc.Fecha_coduccion = reader.GetDateTime(4);
                    lista.Add(cc);
                }

            }
            catch (SqlException e) // warning: variable no utilizada.
            {
                //throw new UsuarioExcepcion("Error en base de datos");
            }
            finally 
            {
                if (conexion != null)
                    conexion.Close();
            }
            return lista;

        }



    }
}