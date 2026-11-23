<?php
require_once __DIR__.'/../config/database.php';
require_once __DIR__.'/../config/auth.php';

exigirLogin();

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$id = (int)($_GET['id'] ?? 0);

$verifica = $pdo->prepare(
    "SELECT COUNT(*) FROM animais WHERE tutor_id = ?"
);

$verifica->execute([$id]);

if ($verifica->fetchColumn() > 0) {

    $_SESSION['mensagem'] =
        'Não é possível excluir este tutor porque existem animais vinculados a ele.';

} else {

    $s = $pdo->prepare("DELETE FROM tutores WHERE id = ?");
    $s->execute([$id]);

    $_SESSION['mensagem'] =
        'Tutor excluído com sucesso.';
}

header('Location: index.php');
exit;
