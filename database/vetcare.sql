CREATE DATABASE IF NOT EXISTS vetcare_djeniffer CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vetcare_djeniffer;

DROP TABLE IF EXISTS consultas;
DROP TABLE IF EXISTS animais;
DROP TABLE IF EXISTS tutores;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  usuario VARCHAR(50) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  perfil VARCHAR(20) DEFAULT 'admin'
);

INSERT INTO usuarios (nome, usuario, senha, perfil) VALUES
('Administrador VetCare', 'admin', 'admin123', 'admin');

CREATE TABLE tutores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(30),
  email VARCHAR(120),
  endereco VARCHAR(180),
  ativo TINYINT(1) DEFAULT 1,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE animais (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tutor_id INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  especie VARCHAR(60),
  raca VARCHAR(80),
  nascimento DATE,
  sexo VARCHAR(20),
  observacoes TEXT,
  ativo TINYINT(1) DEFAULT 1,
  CONSTRAINT fk_animal_tutor FOREIGN KEY (tutor_id) REFERENCES tutores(id)
);

CREATE TABLE consultas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  animal_id INT NOT NULL,
  data_consulta DATETIME NOT NULL,
  veterinario VARCHAR(120) NOT NULL,
  motivo VARCHAR(180),
  status VARCHAR(30) DEFAULT 'Agendada',
  observacoes TEXT,
  CONSTRAINT fk_consulta_animal FOREIGN KEY (animal_id) REFERENCES animais(id)
);

INSERT INTO tutores (nome, telefone, email, endereco, ativo) VALUES
('Mariana Costa', '(47) 99999-1001', 'mariana@email.com', 'Centro', 1),
('Rafael Mendes', '(47) 98888-2002', 'rafael@email.com', 'Bairro Cruzeiro', 1),
('Camila Oliveira', '(47) 97777-3003', 'camila@email.com', 'Serra Alta', 1),
('João Pedro Lima', 'abc123', 'joao@email.com', '25 de Julho', 0);

INSERT INTO animais (tutor_id, nome, especie, raca, nascimento, sexo, observacoes, ativo) VALUES
(1, 'Mel', 'Cão', 'Golden Retriever', '2021-05-10', 'Fêmea', 'Alergia alimentar', 1),
(2, 'Mingau', 'Gato', 'SRD', '2023-11-20', 'Macho', 'Vacinação em dia', 1),
(3, 'Thor', 'Cão', 'Labrador', '2025-10-30', 'Macho', '', 1),
(4, 'Pipoca', 'Coelho', 'Mini Lop', '2024-02-15', 'Fêmea', '', 0);

INSERT INTO consultas (animal_id, data_consulta, veterinario, motivo, status, observacoes) VALUES
(1, DATE_ADD(NOW(), INTERVAL 2 DAY), 'Dra. Paula', 'Retorno dermatológico', 'Agendada', ''),
(2, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Dr. André', 'Avaliação de rotina', 'Realizada', ''),
(3, DATE_ADD(NOW(), INTERVAL 5 DAY), 'Dra. Paula', 'Vacinação', 'Agendada', '');


DROP TABLE IF EXISTS historico_chamados;
DROP TABLE IF EXISTS chamados;

CREATE TABLE chamados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(160) NOT NULL,
  modulo VARCHAR(60) NOT NULL,
  solicitante VARCHAR(120) NOT NULL,
  equipe VARCHAR(100),
  descricao TEXT NOT NULL,
  passos TEXT NOT NULL,
  resultado_esperado TEXT NOT NULL,
  resultado_obtido TEXT NOT NULL,
  severidade ENUM('Baixa','Média','Alta','Crítica') NOT NULL DEFAULT 'Média',
  prioridade ENUM('Baixa','Média','Alta','Urgente') NOT NULL DEFAULT 'Média',
  status ENUM('Aberto','Em análise','Aguardando informações','Resolvido','Fechado') NOT NULL DEFAULT 'Aberto',
  responsavel VARCHAR(120),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE historico_chamados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  chamado_id INT NOT NULL,
  autor VARCHAR(120) NOT NULL,
  comentario TEXT NOT NULL,
  status_anterior VARCHAR(40),
  status_novo VARCHAR(40),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historico_chamado FOREIGN KEY (chamado_id) REFERENCES chamados(id) ON DELETE CASCADE
);


USE vetcare_djeniffer;

SET @solicitante = 'Igor Gabriel';
SET @equipe = 'DS24 M2';

INSERT INTO chamados (
    titulo,
    modulo,
    solicitante,
    equipe,
    descricao,
    passos,
    resultado_esperado,
    resultado_obtido,
    severidade,
    prioridade
) VALUES

(
    'Links de navegação direcionam para páginas incorretas',
    'Outro',
    @solicitante,
    @equipe,
    'Ao acessar páginas internas e utilizar os links do menu de navegação, o sistema pode direcionar para endereços incorretos ou apresentar páginas não encontradas.',
    '1. Acesse o Painel inicial.
2. Entre na página Tutores.
3. Utilize os links do menu para acessar Animais e Consultas.
4. Repita o procedimento em diferentes páginas.
5. Clique em Sair.',
    'Todos os links devem direcionar corretamente às respectivas páginas, independentemente da página em que o usuário esteja.',
    'Os caminhos relativos utilizados no menu provocam direcionamentos incorretos quando o usuário está em diretórios internos.',
    'Alta',
    'Alta'
),

(
    'Formulário de tutor perde os dados preenchidos após validação',
    'Tutores',
    @solicitante,
    @equipe,
    'Quando ocorre uma falha de preenchimento no formulário de tutor, os demais dados informados pelo usuário não são preservados.',
    '1. Acesse Tutores.
2. Clique em Novo tutor.
3. Preencha telefone, e-mail e endereço.
4. Deixe o nome vazio.
5. Clique em Salvar.',
    'O sistema deve apresentar a mensagem de validação e manter os demais campos preenchidos.',
    'Após a validação, os dados anteriormente digitados deixam de aparecer nos campos.',
    'Média',
    'Média'
),

(
    'Botão de cadastro de tutor não abre o formulário',
    'Tutores',
    @solicitante,
    @equipe,
    'Ao clicar no botão Novo tutor, o sistema apresenta uma mensagem de erro e impede o acesso ao formulário.',
    '1. Acesse a página Tutores.
2. Clique em Novo tutor.
3. Observe a mensagem apresentada.',
    'O sistema deve abrir o formulário para cadastrar um novo tutor.',
    'O botão apresenta uma mensagem de erro e não permite acessar o formulário.',
    'Alta',
    'Alta'
),

(
    'Tutores inativos aparecem para novos cadastros de animais',
    'Animais',
    @solicitante,
    @equipe,
    'Durante o cadastro de um novo animal, a seleção de tutores apresenta também pessoas com situação inativa.',
    '1. Acesse Tutores.
2. Identifique um tutor inativo.
3. Acesse Animais.
4. Clique em Novo animal.
5. Abra a seleção de tutores.',
    'O sistema deve apresentar somente tutores ativos para novos vínculos.',
    'A lista apresenta tutores ativos e inativos, permitindo selecionar ambos.',
    'Média',
    'Média'
),

(
    'Exclusão de tutor vinculado a animais não apresenta orientação',
    'Tutores',
    @solicitante,
    @equipe,
    'Ao tentar excluir um tutor que possui animais cadastrados, o sistema não apresenta uma orientação adequada sobre a existência dos vínculos.',
    '1. Acesse Tutores.
2. Localize um tutor que possua animais cadastrados.
3. Clique em Excluir.
4. Observe o comportamento apresentado.',
    'O sistema deve informar que existem animais vinculados e explicar por que a exclusão não pode ser realizada.',
    'A exclusão não é concluída e nenhuma mensagem clara é apresentada ao usuário.',
    'Média',
    'Média'
),

(
    'Animais inativos aparecem sem identificação na listagem',
    'Animais',
    @solicitante,
    @equipe,
    'A listagem de animais apresenta registros ativos e inativos sem indicar visualmente a situação de cada paciente.',
    '1. Acesse Animais.
2. Localize um animal com situação inativa.
3. Observe as informações apresentadas na tabela.',
    'A listagem deve identificar claramente quais animais estão ativos e quais estão inativos.',
    'Os animais aparecem na mesma listagem sem identificação da situação.',
    'Média',
    'Média'
),

(
    'Exclusão de animais não é concluída',
    'Animais',
    @solicitante,
    @equipe,
    'Ao solicitar a exclusão de um animal cadastrado, o sistema não consegue concluir corretamente a operação.',
    '1. Acesse Animais.
2. Escolha um animal cadastrado.
3. Clique em Excluir.
4. Verifique novamente a listagem.',
    'O animal selecionado deve ser removido do cadastro.',
    'O sistema não consegue executar corretamente a exclusão do registro selecionado.',
    'Alta',
    'Alta'
),

(
    'Idade do animal é calculada incorretamente',
    'Animais',
    @solicitante,
    @equipe,
    'A idade apresentada na listagem pode ficar incorreta, pois o cálculo considera apenas o ano de nascimento.',
    '1. Acesse Animais.
2. Localize um animal nascido em 20/12/2021.
3. Observe a idade apresentada antes de 20/12/2026.',
    'O sistema deve calcular a idade considerando dia, mês e ano de nascimento.',
    'O sistema pode apresentar cinco anos, embora o animal ainda tenha quatro anos completos.',
    'Média',
    'Média'
),

(
    'Animais inativos podem receber novas consultas',
    'Consultas',
    @solicitante,
    @equipe,
    'Ao agendar uma consulta, o sistema permite selecionar animais que estão com a situação inativa.',
    '1. Acesse Animais.
2. Identifique um animal inativo.
3. Entre em Consultas.
4. Clique em Nova consulta.
5. Abra a lista de animais.',
    'O sistema deve disponibilizar apenas animais ativos para novos agendamentos.',
    'A lista apresenta animais ativos e inativos, permitindo selecionar ambos.',
    'Alta',
    'Alta'
),

(
    'Filtro de status das consultas não funciona',
    'Consultas',
    @solicitante,
    @equipe,
    'Ao selecionar um status específico no filtro de consultas, a listagem continua apresentando registros de diferentes situações.',
    '1. Acesse Consultas.
2. Selecione Realizada no filtro de status.
3. Clique em Filtrar.
4. Observe os registros apresentados.',
    'A listagem deve apresentar somente consultas com o status selecionado.',
    'O sistema apresenta consultas agendadas, realizadas e canceladas mesmo após a aplicação do filtro.',
    'Média',
    'Alta'
),

(
    'Sistema permite agendar consultas em datas passadas',
    'Consultas',
    @solicitante,
    @equipe,
    'O formulário de agendamento permite informar datas e horários anteriores ao momento atual.',
    '1. Acesse Consultas.
2. Clique em Nova consulta.
3. Selecione um animal.
4. Informe uma data e horário anteriores ao momento atual.
5. Preencha os demais campos.
6. Clique em Salvar.',
    'O sistema deve impedir o agendamento de novas consultas em datas e horários passados.',
    'O sistema permite salvar o agendamento mesmo com uma data anterior à atual.',
    'Média',
    'Média'
),

(
    'Painel inicial apresenta consultas antigas como próximas',
    'Dashboard',
    @solicitante,
    @equipe,
    'Na seção Próximas consultas, o painel inicial apresenta consultas que já ocorreram, dificultando a identificação dos próximos atendimentos.',
    '1. Acesse o sistema.
2. Entre no Painel inicial.
3. Localize Próximas consultas.
4. Observe as datas e os horários apresentados.',
    'O painel deve apresentar somente consultas futuras com status Agendada, organizadas em ordem cronológica.',
    'O painel apresenta consultas anteriores à data atual entre os próximos atendimentos.',
    'Alta',
    'Alta'
);

INSERT INTO historico_chamados (
    chamado_id,
    autor,
    comentario,
    status_novo
)
SELECT
    c.id,
    @solicitante,
    'Chamado registrado na central de suporte.',
    'Aberto'
FROM chamados c
WHERE c.id IN (
    SELECT ids.id
    FROM (
        SELECT id
        FROM chamados
        ORDER BY id DESC
        LIMIT 12
    ) AS ids
);
