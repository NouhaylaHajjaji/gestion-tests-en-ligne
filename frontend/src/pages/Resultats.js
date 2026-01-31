import React, { useState, useEffect, useCallback } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';
import toast from 'react-hot-toast';
import { 
  BarChart3, 
  Trophy, 
  Clock, 
  CheckCircle, 
  XCircle, 
  BookOpen,
  TrendingUp,
  Calendar,
  Award,
  Download
} from 'lucide-react';

const Resultats = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [sessions, setSessions] = useState([]);
  const [selectedSession, setSelectedSession] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchSessions = useCallback(async () => {
    try {
      const response = await fetch(`/api/resultats/candidat/${user.id}`);
      if (response.ok) {
        const data = await response.json();
        setSessions(data.sessions || []); 
        if (data.sessions && data.sessions.length > 0) {
          setSelectedSession(data.sessions[0]);
        }
      } else {
        const errorData = await response.json();
        toast.error(errorData.error || 'Erreur lors du chargement des résultats');
      }
    } catch (error) {
      console.error('Error fetching sessions:', error);
      toast.error('Erreur de connexion au serveur');
    } finally {
      setLoading(false);
    }
  }, [user.id]);

  const downloadRapport = async () => {
    if (!selectedSession) return;
    
    try {
      const response = await fetch(`/api/resultats/rapport/${selectedSession.id}`);
      if (response.ok) {
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `rapport-test-${selectedSession.codeSession}-${new Date().toISOString().split('T')[0]}.pdf`;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
        toast.success('Rapport téléchargé avec succès');
      } else {
        const errorData = await response.json();
        toast.error(errorData.error || 'Erreur lors du téléchargement du rapport');
      }
    } catch (error) {
      console.error('Error downloading rapport:', error);
      toast.error('Erreur de connexion au serveur');
    }
  };

  useEffect(() => {
    if (!user) {
      navigate('/connexion');
      return;
    }
    // Forcer le rechargement des résultats à chaque visite de la page
    fetchSessions();
  }, [user, navigate, fetchSessions]);

  // Ajouter un écouteur d'événements pour recharger les résultats
  useEffect(() => {
    const handleRefresh = () => {
      fetchSessions();
    };

    // Écouter les événements de rafraîchissement personnalisés
    window.addEventListener('refreshResults', handleRefresh);
    
    // Rafraîchir automatiquement après 2 secondes pour être sûr
    const autoRefresh = setTimeout(() => {
      fetchSessions();
    }, 2000);
    
    return () => {
      window.removeEventListener('refreshResults', handleRefresh);
      clearTimeout(autoRefresh);
    };
  }, [fetchSessions]);

  const fetchSessionDetails = async (sessionId) => {
    try {
      const response = await fetch(`/api/resultats/session/${sessionId}`);
      if (response.ok) {
        const data = await response.json();
        setSelectedSession(data);
      }
    } catch (error) {
      console.error('Error fetching session details:', error);
      toast.error('Erreur lors du chargement des détails');
    }
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('fr-FR', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const getScoreColor = (percentage) => {
    if (percentage >= 80) return 'text-green-600';
    if (percentage >= 60) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getScoreBgColor = (percentage) => {
    if (percentage >= 80) return 'bg-green-100';
    if (percentage >= 60) return 'bg-yellow-100';
    return 'bg-red-100';
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="loading"></div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-8">
      <div className="container mx-auto px-4">
        <div className="text-center mb-8 fade-in">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            <Trophy className="inline-block h-8 w-8 text-yellow-500 mr-3" />
            Mes Résultats
          </h1>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Consultez vos performances et suivez votre progression
          </p>
        </div>

        {sessions.length === 0 ? (
          <div className="max-w-md mx-auto">
            <div className="card text-center p-8">
              <div className="mb-6">
                <BarChart3 className="h-16 w-16 text-gray-400 mx-auto" />
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-2">
                Aucun résultat disponible
              </h3>
              <p className="text-gray-600 mb-6">
                Vous n'avez pas encore passé de test. Commencez votre première évaluation !
              </p>
              <button
                onClick={() => navigate('/test')}
                className="btn btn-primary w-full"
              >
                Passer un test
              </button>
            </div>
          </div>
        ) : (
          <div className="max-w-6xl mx-auto">
            {/* Sélection de session */}
            {sessions.length > 1 && (
              <div className="card mb-8 fade-in">
                <div className="card-header">
                  <h3 className="text-lg font-semibold text-gray-900">
                    <Calendar className="inline-block h-5 w-5 mr-2" />
                    Sélectionner une session
                  </h3>
                </div>
                <div className="card-body">
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {sessions.map((session) => (
                      <div
                        key={session.id}
                        onClick={() => setSelectedSession(session)}
                        className={`p-4 rounded-lg border-2 cursor-pointer transition-all hover-lift ${
                          selectedSession?.id === session.id
                            ? 'border-blue-500 bg-blue-50'
                            : 'border-gray-200 bg-white hover:border-gray-300'
                        }`}
                      >
                        <div className="flex justify-between items-start mb-2">
                          <span className="font-semibold text-gray-900">
                            {session.codeSession}
                          </span>
                          <span className={`badge ${
                            session.pourcentage >= 80 ? 'badge-success' :
                            session.pourcentage >= 60 ? 'badge-warning' : 'badge-danger'
                          }`}>
                            {session.pourcentage}%
                          </span>
                        </div>
                        <div className="text-sm text-gray-600">
                          {new Date(session.dateDebut).toLocaleDateString('fr-FR', {
                            day: 'numeric',
                            month: 'long',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                          })}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {selectedSession && (
              <div className="space-y-8 fade-in">
                {/* Score principal */}
                <div className="card hover-lift">
                  <div className="card-body text-center">
                    <div className="inline-flex items-center justify-center w-20 h-20 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 text-white mb-6">
                      <Trophy className="h-10 w-10" />
                    </div>
                    <h2 className="text-4xl font-bold text-gray-900 mb-2">
                      {selectedSession.pourcentage}%
                    </h2>
                    <p className="text-xl text-gray-600 mb-6">
                      {selectedSession.scoreTotal} / {selectedSession.scoreMax} points
                    </p>
                    <div className="grid grid-cols-3 gap-6 max-w-md mx-auto">
                      <div className="text-center">
                        <div className="flex items-center justify-center text-green-600 mb-2">
                          <CheckCircle className="h-6 w-6 mr-2" />
                          <span className="font-bold text-lg">
                            {selectedSession.questionsCorrectes || 0}
                          </span>
                        </div>
                        <p className="text-sm text-gray-600 font-medium">Correctes</p>
                      </div>
                      <div className="text-center">
                        <div className="flex items-center justify-center text-red-600 mb-2">
                          <XCircle className="h-6 w-6 mr-2" />
                          <span className="font-bold text-lg">
                            {selectedSession.questionsIncorrectes || 0}
                          </span>
                        </div>
                        <p className="text-sm text-gray-600 font-medium">Incorrectes</p>
                      </div>
                      <div className="text-center">
                        <div className="flex items-center justify-center text-blue-600 mb-2">
                          <Clock className="h-6 w-6 mr-2" />
                          <span className="font-bold text-lg">
                            {selectedSession.dureeTotale || 'N/A'}
                          </span>
                        </div>
                        <p className="text-sm text-gray-600 font-medium">Durée</p>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Performance par thème */}
                <div className="card hover-lift">
                  <div className="card-header">
                    <h3 className="text-xl font-semibold text-gray-900">
                      <BookOpen className="inline-block h-6 w-6 mr-2" />
                      Performance par thème
                    </h3>
                  </div>
                  <div className="card-body">
                    <div className="space-y-4">
                      {selectedSession.resultatsParTheme?.map((theme) => (
                        <div key={theme.themeId} className="border rounded-lg p-4 hover:bg-gray-50 transition-colors">
                          <div className="flex justify-between items-center mb-3">
                            <div className="flex items-center">
                              <BookOpen className="h-5 w-5 text-gray-600 mr-3" />
                              <span className="font-medium text-gray-900">
                                {theme.nomTheme}
                              </span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <span className="text-sm text-gray-600">
                                {theme.score}/{theme.scoreMax}
                              </span>
                              <span className={`badge ${
                                theme.pourcentage >= 80 ? 'badge-success' :
                                theme.pourcentage >= 60 ? 'badge-warning' : 'badge-danger'
                              }`}>
                                {theme.pourcentage}%
                              </span>
                            </div>
                          </div>
                          <div className="w-full bg-gray-200 rounded-full h-2">
                            <div
                              className="h-2 rounded-full transition-all duration-500"
                              style={{
                                width: `${theme.pourcentage}%`,
                                background: `linear-gradient(90deg, ${
                                  theme.pourcentage >= 80 ? '#22c55e' :
                                  theme.pourcentage >= 60 ? '#f59e0b' : '#ef4444'
                                }, ${
                                  theme.pourcentage >= 80 ? '#16a34a' :
                                  theme.pourcentage >= 60 ? '#d97706' : '#dc2626'
                                })`
                              }}
                            />
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>

                {/* Statistiques avancées */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                  <div className="card hover-lift">
                    <div className="card-header">
                      <h3 className="text-xl font-semibold text-gray-900">
                        <TrendingUp className="inline-block h-6 w-6 mr-2" />
                        Progression
                      </h3>
                    </div>
                    <div className="card-body">
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-sm text-gray-600 mb-1">Classement</p>
                          <p className="font-bold text-2xl text-gray-900">
                            {selectedSession.classement || 'N/A'}
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="text-sm text-gray-600 mb-1">Niveau atteint</p>
                          <p className={`font-bold text-lg ${
                            selectedSession.pourcentage >= 80 ? 'text-green-600' :
                            selectedSession.pourcentage >= 60 ? 'text-yellow-600' : 'text-red-600'
                          }`}>
                            {selectedSession.pourcentage >= 80 ? 'Excellent' :
                             selectedSession.pourcentage >= 60 ? 'Bon' : 'À améliorer'}
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="card hover-lift">
                    <div className="card-header">
                      <h3 className="text-xl font-semibold text-gray-900">
                        <Award className="inline-block h-6 w-6 mr-2" />
                        Réussite
                      </h3>
                    </div>
                    <div className="card-body">
                      <div className="text-center">
                        <div className="relative inline-flex items-center justify-center">
                          <div className="text-5xl font-bold text-gray-900">
                            {selectedSession.pourcentage}%
                          </div>
                          <div className="absolute -top-2 -right-2">
                            {selectedSession.pourcentage >= 80 && (
                              <span className="text-2xl">🏆</span>
                            )}
                            {selectedSession.pourcentage >= 60 && selectedSession.pourcentage < 80 && (
                              <span className="text-2xl">👍</span>
                            )}
                            {selectedSession.pourcentage < 60 && (
                              <span className="text-2xl">📈</span>
                            )}
                          </div>
                        </div>
                        <p className="text-sm text-gray-600 mt-2">
                          {selectedSession.pourcentage >= 80 ? 'Performance exceptionnelle !' :
                           selectedSession.pourcentage >= 60 ? 'Bon travail, continuez !' : 'Continuez à vous améliorer !'}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Actions */}
                <div className="card">
                  <div className="card-body">
                    <div className="flex flex-col sm:flex-row justify-center items-center space-y-4 sm:space-y-0 sm:space-x-6">
                      <button
                        onClick={() => navigate('/test')}
                        className="btn btn-primary w-full sm:w-auto"
                      >
                        Passer un autre test
                      </button>
                      <button
                        onClick={downloadRapport}
                        disabled={!selectedSession}
                        className="btn btn-secondary w-full sm:w-auto disabled:opacity-50 flex items-center justify-center"
                      >
                        <Download className="h-4 w-4 mr-2" />
                        Télécharger le rapport
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default Resultats;
