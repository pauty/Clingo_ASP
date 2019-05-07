import math
import sys 

class giorno():
	aule = []
	docenti = []
	day = ""

	def __init__(self, day):
		#il 6 interno rappresenta le 6 classi, il 6 esterno il numero di ore del giorno
		self.day = day
		self.aule = [[False] * 11 for _ in range(10)] #da 0 a 10, ovvero le 11 aule nelle 6 ore del giorno (da 0 a 5)
		self.docenti = [[False] * 11 for _ in range(10)] #da 0 a 10, ovvero li 11 docenti nelle 6 ore del giorno (da 0 a 5)
		self.classi_pari = [[False] * 6 for _ in range(3)] #3 da classi da 6 ore
		self.classi_dispari = [[False] * 10 for a in range(3)] #3 da classi da 6 ore
	
	def check_entry(self,vector,entry):
		if (vector[entry] == True):
			return False
		else:
			vector[entry] = True
			return True

	def fill_class(self,ora,classe):
		ora = int(ora) - 1 #gli indici vanno da 0 a n-1
		classe = int(classe) 
		if (classe % 2 == 0):
			index_class = (classe - 2) / 2 
			if not self.check_entry(self.classi_pari[int(index_class)], ora):
				print("Error with class: ", (classe), " in hour:", (ora+1), " of ", self.day)
				print(self.classi_pari)
				return False
		else:
			index_class = (classe - 1) / 2
			if not self.check_entry(self.classi_dispari[int(index_class)], ora):
				print("Error with class: ", (classe), " in hour:", (ora+1), " of ", self.day)
				return False
		return True

	def check_aula(self,ora,aula):
		ora = int(ora) - 1 #gli indici vanno da 0 a n-1
		aula = int(aula) - 1
		if not self.check_entry(self.aule[ora], aula):
			print("Error with room: ", (aula+1), " in hour:", (ora+1), " of ", self.day)
			return False

	def check_docente(self,ora,docente):
		ora = int(ora) - 1 #gli indici vanno da 0 a n-1
		docente = int(docente) - 1
		if not self.check_entry(self.docenti[ora], docente):
			print("Error with prof: ", (docente+1), " in hour:", (ora+1), " of ", self.day)
			return False

def check_free_period(lun,mar,mer,gio,ven):
	all(hour == True for hour in lun.classi_pari)
	return True 

#lezione(1,1,let,1,lun,5)
def check_model(solution):
	lun = giorno("lun") 
	mar = giorno("mar") 
	mer = giorno("mer") 
	gio = giorno("gio") 
	ven = giorno("ven") 
	tokens = solution.split()
	ruolo = set()
	count_lessons = 0
	is_good = True
	for token in tokens:
		if 'ruolo' in token:
			token = token[token.index("(")+1:token.index(")")]
			token = token.split(",")
			if ( int(token[2])%2 == 0):
				if (token[1] == "inf" or token[1] == "pit" or token[1] == "edc" or token[1] == "fil"):
					print("Problem with: ", token)
					print("Class ", token[2], "can't have a ", token[1], " lesson.")
					return False 
			ruolo.add((token[0],token[1],token[2]))#uso le tuple perché non posso inserire le liste
		else:
			token = token[token.index("(")+1:token.index(")")]
			token = token.split(",")
			check_ruolo = (token[1],token[2],token[3])
			if not (check_ruolo in ruolo):
				print("Error check_ruolo for teacher: ", token[1], ", course: ", token[2], " and class ", token[3])
				print("Problem with: ", token)
				return False
			if ( int(token[3])%2 == 0):
				if (int(token[5])>6):
					print("Error class: ", token[3], " can't have ", token[5], " hours.")
					print("Problem with: ", token)
					return False
				if (token[2] == "inf" or token[2] == "pit" or token[2] == "edc" or token[2] == "fil"):
					print("Error class: ", token[3], " can't have a ", token[2], " lesson.")
					print("Problem with: ", token)
					return False 
			#check aula
			if (token[4] == "lun"):
				is_good = lun.check_aula(token[5],token[0])
				is_good = lun.check_docente(token[5],token[1])
				is_good = lun.fill_class(token[5],token[3])
			elif (token[4] == "mar"):
				is_good = mar.check_aula(token[5],token[0])
				is_good = mar.check_docente(token[5],token[1])
				is_good = mar.fill_class(token[5],token[3])
			elif (token[4] == "mer"):
				is_good = mer.check_aula(token[5],token[0])
				is_good = mer.check_docente(token[5],token[1])
				is_good = mer.fill_class(token[5],token[3])
			elif (token[4] == "gio"):
				is_good = gio.check_aula(token[5],token[0])
				is_good = gio.check_docente(token[5],token[1])
				is_good = gio.fill_class(token[5],token[3])
			elif (token[4] == "ven"):
				is_good = ven.check_aula(token[5],token[0])
				is_good = ven.check_docente(token[5],token[1])
				is_good = ven.fill_class(token[5],token[3])

			#is_good = check_free_period(lun,mar,mer,gio,ven)

			if not is_good:
				print("Problem with: ", token)
				return False
			count_lessons += 1

	if not (len(ruolo) == 72):
		print("Cardinality of set 'ruolo' is ", len(ruolo) ," and not 72")
	if not (count_lessons == 210):
		print("The nember of lessons is ", count_lessons ," and not 210")
	return True


if __name__ == '__main__':
    namefile = sys.argv[1]
    no_error = True
    with open(namefile, 'r') as input:
	    for line in input:
		    if (no_error == False):
			    print("Answer is broken")
			    break
		    if 'Answer' in line or "ruolo" in line:
			    if 'ruolo' in line:
				    no_error = check_model(line)
				    print("checked")
			    else:
				    print(line) #mi serve per capire quale ha checkatosai qua
			

