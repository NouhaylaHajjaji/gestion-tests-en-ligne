import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import toast from 'react-hot-toast';
import { 
  Clock, 
  CheckCircle,
  Play
} from 'lucide-react';

const Test = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [session, setSession] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [answers, setAnswers] = useState({});
  const [timeLeft, setTimeLeft] = useState(0);
  const [isStarted, setIsStarted] = useState(false);
  const [isFinished, setIsFinished] = useState(false);
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const checkExistingSession = useCallback(async () => {
    try {
      const response = await fetch('/api/tests/session-active', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ codeSession: user.codeSession }),
      });

      if (response.ok) {
        const data = await response.json();
        if (data.session) {
          setSession(data.session);
          setQuestions(data.questions);
          setCurrentQuestionIndex(data.currentQuestionIndex || 0);
          setAnswers(data.answers || {});
          setTimeLeft(data.timeLeft || 0);
          setIsStarted(true);
        }
      }
    } catch (error) {
      console.error('Error checking session:', error);
    }
  }, [user]);

  const handleSubmitTest = useCallback(async () => {
    setSubmitting(true);
    try {
      const response = await fetch('/api/tests/soumettre', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          sessionId: session.id,
          answers
        }),
      });

      let data;
      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        data = await response.json();
      } else {
        const text = await response.text();
        console.error('Non-JSON response:', text);
        data = { error: text };
      }

      if (response.ok) {
        setIsFinished(true);
        toast.success('Test terminé !');
        
        // Attendre un peu pour s'assurer que les données sont bien enregistrées
        setTimeout(() => {
          // Déclencher un événement pour rafraîchir les résultats
          window.dispatchEvent(new CustomEvent('refreshResults'));
          
          setTimeout(() => {
            navigate('/resultats');
          }, 500);
        }, 1000);
      } else {
        toast.error(data.error || 'Erreur lors de la soumission');
      }
    } catch (error) {
      console.error('Error submitting test:', error);
      toast.error('Erreur de connexion au serveur');
    } finally {
      setSubmitting(false);
    }
  }, [session, navigate, answers]);

  useEffect(() => {
    if (!user) {
      navigate('/connexion');
      return;
    }
    checkExistingSession();
  }, [user, navigate, checkExistingSession]);

  useEffect(() => {
    let timer;
    if (isStarted && !isFinished && timeLeft > 0) {
      timer = setTimeout(() => {
        setTimeLeft(timeLeft - 1);
      }, 1000);
    } else if (timeLeft === 0 && isStarted && !isFinished) {
      handleSubmitTest();
    }
    return () => clearTimeout(timer);
  }, [timeLeft, isStarted, isFinished, handleSubmitTest]);

  const startTest = async () => {
    setLoading(true);
    try {
      const response = await fetch('/api/tests/demarrer', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ codeSession: user.codeSession }),
      });

      const data = await response.json();

      if (response.ok) {
        setSession(data.session);
        setQuestions(data.questions);
        setCurrentQuestionIndex(0);
        setAnswers({});
        setTimeLeft(data.questions.length * 120); // 2 minutes par question
        setIsStarted(true);
        toast.success('Test démarré !');
      } else {
        toast.error(data.error || 'Erreur lors du démarrage du test');
      }
    } catch (error) {
      console.error('Error starting test:', error);
      toast.error('Erreur de connexion au serveur');
    } finally {
      setLoading(false);
    }
  };

  const handleAnswer = (questionId, answer) => {
    setAnswers(prev => ({
      ...prev,
      [questionId]: answer
    }));
  };

  const saveAnswer = async (questionId) => {
    const answer = answers[questionId];
    if (!answer || !session) return;

    try {
      const response = await fetch('/api/tests/reponse', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          sessionId: session.id,
          questionId,
          reponseData: answer
        }),
      });

      if (response.ok) {
        console.log('Réponse sauvegardée automatiquement');
      } else {
        console.error('Erreur sauvegarde réponse:', await response.text());
      }
    } catch (error) {
      console.error('Erreur sauvegarde réponse:', error);
    }
  };

  const nextQuestion = async () => {
    // Sauvegarder la réponse actuelle avant de changer
    if (currentQuestion) {
      await saveAnswer(currentQuestion.id);
    }
    
    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    }
  };

  const previousQuestion = async () => {
    // Sauvegarder la réponse actuelle avant de changer
    if (currentQuestion) {
      await saveAnswer(currentQuestion.id);
    }
    
    if (currentQuestionIndex > 0) {
      setCurrentQuestionIndex(currentQuestionIndex - 1);
    }
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const currentQuestion = questions[currentQuestionIndex]?.question || questions[currentQuestionIndex];

  if (!user) {
    return null;
  }

  if (isFinished) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <CheckCircle className="h-16 w-16 text-green-600 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            Test terminé !
          </h2>
          <p className="text-gray-600 mb-4">
            Redirection vers vos résultats...
          </p>
        </div>
      </div>
    );
  }

  if (!isStarted) {
    return (
      <div className="min-h-screen flex items-center justify-center py-12">
        <div className="max-w-md w-full">
          <div className="text-center">
            <div className="mx-auto h-12 w-12 flex items-center justify-center rounded-full bg-blue-100 mb-4">
              <Play className="h-6 w-6 text-blue-600" />
            </div>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Prêt à commencer le test ?
            </h2>
            <p className="text-gray-600 mb-8">
              Vous aurez {questions.length || 30} questions avec 2 minutes pour chacune.
            </p>
            <button
              onClick={startTest}
              disabled={loading}
              className="btn btn-primary w-full disabled:opacity-50"
            >
              {loading ? 'Chargement...' : 'Commencer le test'}
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen py-8">
      <div className="container mx-auto px-4 max-w-4xl">
        {/* Header */}
        <div className="bg-white rounded-lg shadow-lg p-6 mb-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                Test en cours
              </h1>
              <p className="text-gray-600">
                Question {currentQuestionIndex + 1} sur {questions.length}
              </p>
            </div>
            <div className={`flex items-center space-x-2 px-4 py-2 rounded-lg ${
              timeLeft < 60 ? 'bg-red-100 text-red-800' : 'bg-blue-100 text-blue-800'
            }`}>
              <Clock className="h-5 w-5" />
              <span className="font-mono font-bold">
                {formatTime(timeLeft)}
              </span>
            </div>
          </div>
          
          {/* Progress bar */}
          <div className="mt-4">
            <div className="w-full bg-gray-200 rounded-full h-2">
              <div 
                className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                style={{ width: `${((currentQuestionIndex + 1) / questions.length) * 100}%` }}
              ></div>
            </div>
          </div>
        </div>

        {/* Question */}
        {currentQuestion && (
          <div className="bg-white rounded-lg shadow-lg p-8 mb-6">
            <div className="mb-6">
              <div className="flex items-center justify-between mb-4">
                <span className="bg-blue-100 text-blue-800 text-sm font-medium px-3 py-1 rounded-full">
                  Question {currentQuestionIndex + 1}
                </span>
                <span className="bg-gray-100 text-gray-800 text-sm font-medium px-3 py-1 rounded-full">
                  {currentQuestion.typeQuestion?.nom}
                </span>
              </div>
              <h2 className="text-xl font-semibold text-gray-900 mb-4">
                {currentQuestion.libelle}
              </h2>
            </div>

            {/* Réponses */}
            <div className="space-y-3">
              {currentQuestion.reponsesPossibles?.map((reponse) => (
                <label
                  key={reponse.id}
                  className={`flex items-center p-4 border rounded-lg cursor-pointer transition-all hover:bg-gray-50 ${
                    answers[currentQuestion.id]?.reponsePossibleId === reponse.id
                      ? 'border-blue-500 bg-blue-50'
                      : 'border-gray-200'
                  }`}
                >
                  <input
                    type="radio"
                    name={`question-${currentQuestion.id}`}
                    checked={answers[currentQuestion.id]?.reponsePossibleId === reponse.id}
                    onChange={(e) => {
                      if (e.target.checked) {
                        setAnswers({
                          ...answers,
                          [currentQuestion.id]: {
                            reponsePossibleId: reponse.id,
                            reponseText: null
                          }
                        });
                      }
                    }}
                    className="mr-3"
                  />
                  <span className="ml-3 text-gray-700">{reponse.libelle}</span>
                </label>
              ))}
            </div>

            {/* Zone de réponse textuelle - disponible pour toutes les questions */}
            <div className="mt-6 p-4 bg-gray-50 rounded-lg">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Ou écrivez votre réponse détaillée :
              </label>
              <textarea
                className="input w-full"
                rows={4}
                placeholder="Tapez votre réponse ici si aucune des options ci-dessus ne vous convient..."
                value={answers[currentQuestion.id]?.reponseText || ''}
                onChange={(e) => {
                  setAnswers({
                    ...answers,
                    [currentQuestion.id]: {
                      reponseText: e.target.value,
                      reponsePossibleId: null
                    }
                  });
                }}
              />
              <p className="text-xs text-gray-500 mt-2">
                💡 Les réponses textuelles sont évaluées automatiquement par comparaison avec les réponses correctes
              </p>
            </div>
          </div>
        )}

        {/* Navigation */}
        <div className="flex justify-between items-center">
          <button
            onClick={previousQuestion}
            disabled={currentQuestionIndex === 0}
            className="btn btn-secondary disabled:opacity-50"
          >
            Précédent
          </button>

          <div className="flex space-x-2">
            {questions.map((q, index) => (
              <button
                key={index}
                onClick={() => setCurrentQuestionIndex(index)}
                className={`w-10 h-10 rounded-full font-medium transition-all ${
                  index === currentQuestionIndex
                    ? 'bg-blue-600 text-white'
                    : answers[(q.question?.id || q.id)]
                    ? 'bg-green-100 text-green-800'
                    : 'bg-gray-200 text-gray-600'
                }`}
              >
                {index + 1}
              </button>
            ))}
          </div>

          {currentQuestionIndex === questions.length - 1 ? (
            <button
              onClick={handleSubmitTest}
              disabled={submitting}
              className="btn btn-success disabled:opacity-50"
            >
              {submitting ? 'Soumission...' : 'Terminer le test'}
            </button>
          ) : (
            <button
              onClick={nextQuestion}
              className="btn btn-primary"
            >
              Suivant
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default Test;
