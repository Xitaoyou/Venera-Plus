const updateRepository = String.fromEnvironment('VENERA_UPDATE_REPO', defaultValue: 'Xitaoyou/Venera-Plus');
const updateRepositoryUrl = 'https://github.com/$updateRepository';
const updateApiBase = 'https://api.github.com/repos/$updateRepository';
const updateReleaseBase = '$updateRepositoryUrl/releases';
