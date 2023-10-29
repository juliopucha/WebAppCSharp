using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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

        public List<Paquete> RecuperarTodosLosPaquetes()
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

        // https://learn.microsoft.com/es-es/sql/relational-databases/security/sql-injection?view=sql-server-ver16
        // https://dotnettutorials.net/lesson/ado-net-sqldataadapter/
        public List<Paquete> RecuperarLosPaquetesEnviadosAUnaProvincia(string provincia) 
        {
            Conectar();
            List<Paquete> paquetes = new List<Paquete>();
            //-- funciona, pero, no protege contra "inyecci-on SQL" cuando el usuario
            //-- ingresa valores sin utilizar Procedimientos Almacenados.
            /* SqlCommand comm = new SqlCommand("SELECT * FROM PAQUETE WHERE PROVINCIA_DESTINO = '" +
                provincia + "'", conexion); */
            SqlCommand comm = new SqlCommand("SELECT * FROM PAQUETE WHERE PROVINCIA_DESTINO = " +
                "@provinciaDestino", conexion);
            conexion.Open();

            // es m-as seguro si se ingresa el valor como par-ametro y no como una simple
            // cadena de caracteres que forma parte de un comando Sql.
            comm.Parameters.AddWithValue("@provinciaDestino", provincia);
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


        // https://learn.microsoft.com/es-es/sql/relational-databases/security/sql-injection?view=sql-server-ver16
        // https://dotnettutorials.net/lesson/ado-net-sqldataadapter/
        /** 
         * SqlDataAdapter se utliza cuando se desea trabajar con tablas en memoria RAM 
         * que tienen pocos registros. Tambi-en cuando se requiere hacer operaciones
         * offline y compleja manipulaci-on o modificaci-on de datos en la BDD.         *
         **/
        //--uso de SqlDataAdapter: en este caso sin SP existente en una BDD de SQL Server,
        // sin embargo, SqlDataAdapter tambi-en puede trabajar con SPs.
        // Aqu-i se usa DataTable, aunque, tambi-en se puede utilizar DataSet.
        public List<Paquete> informacionDeUnPaquetePorCodigo(string codigo)
        {
            Conectar();
            List<Paquete> lista = new List<Paquete>();

            try
            {
                SqlDataAdapter comandoSDA = new SqlDataAdapter("SELECT * FROM PAQUETE WHERE COD_PAQUETE = " +
                "@codigoPaquete", conexion);
                // si se utilizara con SP, la l-inea anterior ser-ia as-i:
                /* SqlDataAdapter comandoSDA = new SqlDataAdapter("pa_nombre_del_procedimiento_almacenado", conexion); */
                conexion.Open();

                comandoSDA.SelectCommand.CommandType = System.Data.CommandType.Text;
                // si accediera a un SP, la l-inea anterior ser-ia as-i:
                /* comandoSDA.SelectCommand.CommandType = System.Data.CommandType.StoredProcedure; */
                SqlParameter parametro = comandoSDA.SelectCommand.Parameters.Add("@codigoPaquete",
                    System.Data.SqlDbType.VarChar, 5);
                // al ingresar un string menos de 5, no muestra ninguna fila, si es mayor que 5 y los primeros
                // 5 caracteres est-an correctos o existen en la BDD, nuestra ese registro involucrado, esto
                // porque, SQL recorta o borra el exceso de caracteres.
                parametro.Value = codigo;

                //-- Con el m-etodo DataTable
                /* DataTable dataTable = new DataTable();
                comandoSDA.Fill(dataTable);// int nFilas = comandoSDA.Fill(dataTable);
                // El m-etodo Fill realiza las siguientes tareas:
                // 1.- Abre la conexi-on
                // 2.- Ejecuta el comando
                // 3.- Captura, recupera o retiene el resultado del comando
                // 4.- Rellena/Almacena en la "Tabla de Datos" el resultado retenido
                // 5.- Cierra la conexi-on.

                //-------------------------------------
                // En este punto, no se requiere "Activar" y "Abrir" la conexi-on.
                // dataTable.Rows: obtiene la colecci-on de filas que pertenecen a esa tabla.
                // DataRow: representa una fila de los datos en una "DataTable".

                foreach (DataRow fila in dataTable.Rows)
                {
                    Paquete paq = new Paquete
                    {
                        Cod_paquete = fila["COD_PAQUETE"].ToString(),
                        Descripcion = fila["DESCRIPCION"].ToString(),
                        Destinatario = fila["DESTINATARIO"].ToString(),
                        Direccion_destinatario = fila["DIRECCION_DESTINATARIO"].ToString(),
                        Cedula_conductor = fila["CEDULA_CONDUCTOR"].ToString(),
                        Provincia_destino = fila["PROVINCIA_DESTINO"].ToString()
                    };
                    lista.Add(paq);
                }*/

                //-- Otra opci-on con DataSet
                DataSet dataSet = new DataSet();
                comandoSDA.Fill(dataSet, "tablaPaquete");

                foreach ( DataRow fila in dataSet.Tables["tablaPaquete"].Rows ) 
                {
                    Paquete paq = new Paquete
                    {
                        // Se accede al valor usando la cadena "NombreDeColumna" como "Clave"                        
                        Cod_paquete = fila["COD_PAQUETE"].ToString(),
                        Descripcion = fila["DESCRIPCION"].ToString(),
                        Destinatario = fila["DESTINATARIO"].ToString(),
                        Direccion_destinatario = fila["DIRECCION_DESTINATARIO"].ToString(),
                        Cedula_conductor = fila["CEDULA_CONDUCTOR"].ToString(),
                        Provincia_destino = fila["PROVINCIA_DESTINO"].ToString()
                        // Tambi-en se puede acceder mediante el -indice de la posici-on
                        // el cual es de tipo entero y empieza en cero:
                        // Cod_paquete = fila[0].ToString()
                    };
                    lista.Add(paq);
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

        //------------------------------------------------------------------------------------------------
        // Observaci-on: el SP "pa_conductor_conduce_camion_por_placa" combina
        // la tabla "Conductor" y la tabla "Camion"
        //-- el m-etodo "conductoresConducenCamionesPorPlaca" permite el
        //-- acceso a los datos con el nombre de un SP existente en una BDD de
        //-- SQL Server, con SqlCommand, y SqlDataReader
        public List<ConductorCamion> conductoresConducenCamionesPorPlaca(string placa)
        {
            Conectar();
            List<ConductorCamion> lista = new List<ConductorCamion>();

            try
            {
                SqlCommand comando = new SqlCommand("pa_conductor_conduce_camion_por_placa", conexion);
                conexion.Open();
                comando.CommandType = System.Data.CommandType.StoredProcedure;
                //-- Esto es m-as simple, pero, no permite hacer validaci-on
                /*comando.Parameters.AddWithValue("@placacamion", placa);*/

                /* inicio del reemplazo de AddWithValue */
                //-- Tambi-en funciona, pero, en realidad no se sabe si la
                //-- validaci-on de la longitud de 11 caracteres est-a funcionando.             
                SqlParameter entrada = new SqlParameter("@placacamion", 
                    System.Data.SqlDbType.VarChar, 11);
                entrada.Direction = System.Data.ParameterDirection.Input;
                entrada.Value = placa;
                comando.Parameters.Add(entrada);
                /* fin del reemplazo de AddWithValue */

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