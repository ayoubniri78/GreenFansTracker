package dev.ayoub.ActionService.model;

import java.io.InputStream;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Action")
@Data
@NoArgsConstructor

public class Action {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	private int supporterId;

	private String type;

	private int points;

	@Enumerated(EnumType.STRING)
	private STATUS status = STATUS.PENDING;

	private Date submissionDate;

	private String details;

//	@ElementCollection
//	@CollectionTable(name = "action_validation_votes", joinColumns = @JoinColumn(name = "action_id"))
//	@MapKeyColumn(name = "supporter_id")
//	@Column(name = "vote_value")
//
//	Map<String, Integer> votes; // <vote,idSuppVoter>
//	@ElementCollection(fetch = FetchType.EAGER)
//	@CollectionTable(name = "action_validation_votes", joinColumns = @JoinColumn(name = "action_id"))
//	@MapKeyColumn(name = "vote_type")        // Clé : type de vote (String)
//	@Column(name = "supporter_count")        // Valeur : nombre de votes (Integer)
//	private Map<String, Integer> votes;      // <vote_type, count>
	@ElementCollection(fetch = FetchType.EAGER)
	@CollectionTable(name = "action_validation_votes", joinColumns = @JoinColumn(name = "action_id"))
	@MapKeyColumn(name = "supporter_id")        
	@Column(name = "vote_value")                
	private Map<Integer, String> votes;         

	private String mediaFileName;
	private String mediaFileType;
	private String mediaFilePath;

	public void setMedia(String mediaFileName, String mediaFileType, String mediaFilePath) {
		this.mediaFileName = mediaFileName;
		this.mediaFilePath = mediaFilePath;
		this.mediaFileType = mediaFileType;
	}

	public Action(int supporterId, String type, int points, STATUS status, Date submissionDate, String detail,
			Map<Integer, String> votes, String mediaFileName, String mediaFileType, String mediaFilePath) {
		super();
		this.supporterId = supporterId;
		this.type = type;
		this.points = points;
		this.status = status;
		this.submissionDate = submissionDate;
		this.details = detail;
		this.votes = votes;
		this.mediaFileName = mediaFileName;
		this.mediaFileType = mediaFileType;
		this.mediaFilePath = mediaFilePath;
	}
//	Action submitAction(int suppId,String type,String detail,int points,InputStream fileStream,String fileName,String fileType);

	public Action(int supporterId, String type, String details, int points, String mediaFileName, String mediaFileType,
			String mediaFilePath) {
		this.supporterId = supporterId;
		this.type = type;
		this.details = details; 
		this.points = points;
		this.submissionDate = new java.sql.Date(System.currentTimeMillis());
		this.status = STATUS.PENDING; 
		this.votes = new HashMap<>(); 
		this.mediaFileName = mediaFileName;
		this.mediaFileType = mediaFileType;
		this.mediaFilePath = mediaFilePath;
	}

}
