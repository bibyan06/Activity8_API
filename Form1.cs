using System;
using System.Collections.Generic;
using System.Data;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json;

namespace CsharpApi
{
    public partial class Form1 : Form
    {
        private List<Department> departments;
        public Form1()
        {
            InitializeComponent();
            LoadDepartments();
            departmentsComboBox.SelectedIndexChanged += DepartmentsComboBox_SelectedIndexChanged;
        }

        // POST Method Process
        private async void btnPost_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;
            string email = txtEmail.Text;
            int dname = departments[departmentsComboBox.SelectedIndex].dnumber;
            int totalsalary = dname;

            var userData = new
            {
                username = username,
                pass = password,
                email = email,
                dname = dname,
                totalsalary = totalsalary
            };

            var jsonData = JsonConvert.SerializeObject(userData);

            using (var client = new HttpClient())
            {
                var content = new StringContent(jsonData, Encoding.UTF8, "application/json");
                var response = await client.PostAsync("http://localhost/Act8_API/api.php", content);
                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("User added successfully");
                    ClearInputFields();
                }
                else
                {
                    string responseContent = await response.Content.ReadAsStringAsync();
                    MessageBox.Show($"Failed to add user: {responseContent}");
                }
            }
        }

        // GET Method Process
        private async void btnGet_Click(object sender, EventArgs e)
        {
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync("http://localhost/Act8_API/api.php?action=getUsers");

                if (response.IsSuccessStatusCode)
                {
                    var jsonData = await response.Content.ReadAsStringAsync();
                    try
                    {
                        var users = JsonConvert.DeserializeObject<List<User>>(jsonData);

                        DataTable dataTable = new DataTable();
                        dataTable.Columns.Add("Username");
                        dataTable.Columns.Add("Password");
                        dataTable.Columns.Add("Email");
                        dataTable.Columns.Add("Department Name");
                        dataTable.Columns.Add("Total Salary");

                        foreach (var user in users)
                        {
                            dataTable.Rows.Add(user.username, user.pass, user.email, user.dname, user.totalsalary);
                        }

                        accounts.DataSource = dataTable;
                    }
                    catch (JsonException ex)
                    {
                        MessageBox.Show($"Error parsing user data: {ex.Message}");
                    }
                }
                else
                {
                    string responseContent = await response.Content.ReadAsStringAsync();
                    MessageBox.Show($"Failed to fetch data from the server: {responseContent}");
                }
            }
        }

        // Load Departments
        private async void LoadDepartments()
        {
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync("http://localhost/Act8_API/api.php?action=getDepartments");

                if (response.IsSuccessStatusCode)
                {
                    var jsonData = await response.Content.ReadAsStringAsync();
                    try
                    {
                        departments = JsonConvert.DeserializeObject<List<Department>>(jsonData);

                        departmentsComboBox.Items.Clear();

                        foreach (var department in departments)
                        {
                            departmentsComboBox.Items.Add(department.dname);
                        }
                    }
                    catch (JsonException ex)
                    {
                        MessageBox.Show($"Error parsing department data: {ex.Message}");
                    }
                }
                else
                {
                    string responseContent = await response.Content.ReadAsStringAsync();
                    MessageBox.Show($"Failed to fetch departments from the server: {responseContent}");
                }
            }
        }

        // Department Selection Changed
        private async void DepartmentsComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (departmentsComboBox.SelectedIndex == -1)
                return;

            var selectedDepartment = departments[departmentsComboBox.SelectedIndex];
            int dnumber = selectedDepartment.dnumber;

            using (var client = new HttpClient())
            {
                var response = await client.GetAsync($"http://localhost/Act8_API/api.php?action=getTotalSalary&dnumber={dnumber}");

                if (response.IsSuccessStatusCode)
                {
                    var jsonData = await response.Content.ReadAsStringAsync();
                    try
                    {
                        var totalsalary = JsonConvert.DeserializeObject<TotalSalary>(jsonData);
                        txtTotalSalary.Text = totalsalary.totalsalary.ToString();
                    }
                    catch (JsonException ex)
                    {
                        MessageBox.Show($"Error parsing total salary data: {ex.Message}");
                    }
                }
                else
                {
                    string responseContent = await response.Content.ReadAsStringAsync();
                    MessageBox.Show($"Failed to fetch total salary from the server: {responseContent}");
                }
            }
        }

        private void ClearInputFields()
        {
            txtUsername.Text = "";
            txtPassword.Text = "";
            txtPassword.Text = "";
            txtEmail.Text = "";
            txtTotalSalary.Text = "";
        }

        class TotalSalary
        {
            public int totalsalary { get; set; }
        }

        public class User
        {
            public string username { get; set; }
            public string pass { get; set; }
            public string email { get; set; }
            public string dname { get; set; }
            public int totalsalary { get; set; }
        }

        public class Department
        {
            public string dname { get; set; }
            public int dnumber { get; set; }
        }
    }
}
