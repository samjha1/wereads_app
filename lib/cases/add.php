<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Allow POST and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header
header('Content-Type: application/json'); // Set content type to JSON

// Handle the OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection (adjust as necessary for your environment)
$servername = '217.21.91.52';
$dbname = 'u320979224_wereads';
$username = 'u320979224_wereads'; // Your database username
$password = 'A5~o[?[6L+m'; // Your database password

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

// Process the form data (POST method expected)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect data
    $data = $_POST;

    // Validate the data (basic example)
    $required_fields = ['client_name', 'court', 'court_hall', 'case_type', 'case_number', 'case_year', 'party_name', 'o_party', 'title1'];

    foreach ($required_fields as $field) {
        if (empty($data[$field])) {
            echo json_encode(['error' => "$field is required"]);
            exit();
        }
    }

    // Sanitize the inputs to prevent SQL injection
    $client_name = htmlspecialchars(trim($data['client_name']));
    $court_hall = htmlspecialchars(trim($data['court_hall']));
    $court = htmlspecialchars(trim($data['court']));
    $case_type = htmlspecialchars(trim($data['case_type']));
    $case_number = htmlspecialchars(trim($data['case_number']));
    $case_year = htmlspecialchars(trim($data['case_year']));
    $party_name = htmlspecialchars(trim($data['party_name']));
    $o_party = htmlspecialchars(trim($data['o_party']));
    $title1 = htmlspecialchars(trim($data['title1']));

    // Insert data into the database
    try {
        $sql = "INSERT INTO advocate_master (client_name, court, court_hall, case_type, case_number, case_year, party_name, o_party, title1) 
                VALUES (:client_name, :court, :court_hall, :case_type, :case_number, :case_year, :party_name, :o_party, :title1)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':client_name' => $client_name,
            ':court_hall' => $court_hall,
            ':court' => $court,
            ':case_type' => $case_type,
            ':case_number' => $case_number,
            ':case_year' => $case_year,
            ':party_name' => $party_name,
            ':o_party' => $o_party,
            ':title1' => $title1,
        ]);

        echo json_encode(['message' => 'Data submitted successfully']);
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>
