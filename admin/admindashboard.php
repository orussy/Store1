<?php
// Include authentication check - this will automatically redirect non-admin users
require_once 'auth_check.php';

// Get admin info
$adminInfo = getAdminInfo();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Store1</title>
    <link rel="stylesheet" href="../style/admin.css">
</head>
<body>
    <div class="admin-header">
        <h1>🔐 Admin Dashboard</h1>
        <div class="admin-info">
            Welcome, <strong><?php echo htmlspecialchars($adminInfo['email']); ?></strong> | 
            Role: <strong><?php echo htmlspecialchars($adminInfo['role']); ?></strong> | 
            User ID: <strong><?php echo htmlspecialchars($adminInfo['user_id']); ?></strong>
        </div>
    </div>

    <div class="admin-content">
        <h2>👥 User Management</h2>
        <p>Manage all registered users in the system.</p>
        
        <table class="user-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php
                include '../config/db.php';
                
                $sql = "SELECT id, email, f_name, l_name, role, status FROM users ORDER BY id DESC";
                $result = mysqli_query($conn, $sql);
                
                if (mysqli_num_rows($result) > 0) {
                    while ($row = mysqli_fetch_assoc($result)) {
                        echo "<tr>";
                        echo "<td>" . htmlspecialchars($row['id']) . "</td>";
                        echo "<td>" . htmlspecialchars($row['email']) . "</td>";
                        echo "<td>" . htmlspecialchars($row['f_name']) . "</td>";
                        echo "<td>" . htmlspecialchars($row['l_name']) . "</td>";
                        echo "<td><span class='role-" . htmlspecialchars($row['role']) . "'>" . htmlspecialchars($row['role']) . "</span></td>";
                        echo "<td><span class='status-" . htmlspecialchars($row['status']) . "'>" . htmlspecialchars($row['status']) . "</span></td>";
                        echo "<td>";
                        if ($row['role'] !== 'admin') {
                            echo "<button onclick='toggleUserStatus(" . $row['id'] . ", \"" . $row['status'] . "\")' class='action-btn' style='background: " . ($row['status'] === 'active' ? '#dc3545' : '#28a745') . "; color: white;'>" . ($row['status'] === 'active' ? 'Block' : 'Activate') . "</button>";
                        }
                        echo "</td>";
                        echo "</tr>";
                    }
                } else {
                    echo "<tr><td colspan='7' style='text-align: center;'>No users found</td></tr>";
                }
                
                mysqli_close($conn);
                ?>
            </tbody>
        </table>
        
        <a href="../logout.php" class="logout-btn">🚪 Logout</a>
    </div>

    <script>
        function toggleUserStatus(userId, currentStatus) {
            if (confirm('Are you sure you want to ' + (currentStatus === 'active' ? 'block' : 'activate') + ' this user?')) {
                // You can implement AJAX call here to toggle user status
                alert('User status toggle functionality can be implemented here');
            }
        }
    </script>
</body>
</html>