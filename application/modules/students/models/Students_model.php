<?php 


/**
 * 
 */
class Students_model extends CI_model
{
  
  function __construct()
  {
    // code...
    parent::__construct();
  }

  public function countAll($centerId=false)
  {
    // code...
    if (!empty($centerId)) {
      $sql = "SELECT count(*) as totalstudent FROM `epupils` JOIN eschoolyear_by_worker_students ON studentId = pupilsId JOIN eschoolyear_by_worker ON eschoolyear_by_worker.workersId = eschoolyear_by_worker_students.workersId JOIN eworkers ON eworkers.workersId = eschoolyear_by_worker.workersId where centerId = ?";
      $query = $this->db->query($sql, array($centerId));
    }else{

    $this->db->select('*');
    $this->db->from('epupils');
    $query = $this->db->get();

    }
    return $query->num_rows();
    }

  public function listAll($centerId=false)
  {
    // code...

    if (!empty($centerId)) {
      $sql = "SELECT count(*) as totalstudent FROM `epupils` JOIN eschoolyear_by_worker_students ON studentId = pupilsId JOIN eschoolyear_by_worker ON eschoolyear_by_worker.workersId = eschoolyear_by_worker_students.workersId JOIN eworkers ON eworkers.workersId = eschoolyear_by_worker.workersId where centerId = ?";
      $query = $this->db->query($sql, array($centerId));
    }else{

    $this->db->select('*');
    $this->db->from('epupils');
    $query = $this->db->get();

    }
    return $query->result();
    }

  
    public function listAllnotenroll($YearId,$workersId)
  {
    // code...
    if($data = $this->listbyclassess($YearId,$workersId)){
      $ids = array();
      //var_dump($data);
        foreach ($data as $key => $value) {
          // code...
          array_push($ids, $value->id);
        }
    } 
    $data3 = array(); 
    if (!empty($ids)) {
      // code...

    if($data2 = $this->listAll()){
      foreach ($data2 as $a => $b) {
        // code...
        if (!in_array($b->pupilsId,$ids)) {
          // code...
          $data3[] = $b;
        }

      }

    }
    }
    return $data3;
    
  }
  public function listallmystudent($worker_id=0)
  {
    // code...
    return $this->db->get_where('center_students_schoolyear',array('worker_id'=>$worker_id))->result();
  }
  
    public function listmystudents($YearId,$workersId)
  {
    // code...
    $this->db->select("pupilsId as id, workersId ,YearId  ,CONCAT(fName,' ', mName,' ', lName,' ', ext) as studentName,address,gender,age,StudentType,birthDate");
    $this->db->from('epupils');
    $this->db->join('eschoolyear_by_worker_students s','s.studentId = pupilsId','inner');
    $this->db->order_by('studentName','asc');
    $this->db->group_by('pupilsId,workersId,StudentType');
    $this->db->where('YearId',$YearId);
    $this->db->where('workersId',$workersId  );

    $query = $this->db->get(); 
    
    return $query->result();
  }
  
    public function listbyclassess($YearId,$workersId)
  {
    // code...
    $this->db->select("c.pupilsId as id, CONCAT(c.fName,' ', c.mName,' ', c.lName,' ', c.ext) as studentName,c.weight,c.height");
    $this->db->from('eschoolyear_by_worker a');
    $this->db->join('eschoolyear_by_worker_students b','b.YearId = a.YearId','left');
    $this->db->join('epupils c','c.pupilsId = b.studentId','left');
    $this->db->order_by('studentName','asc');
    $this->db->group_by('pupilsId');
    $this->db->where('b.YearId',$YearId);
    $this->db->where('b.workersId',$workersId  );
    $query = $this->db->get();
    return $query->result();
  }

    public function listbyclassess2($YearId,$workersId)
  {
    // code...
    $this->db->select("pupilsId as id, CONCAT(a.fName,' ', a.mName,' ', a.lName,' ', a.ext) as studentName,weight,height");
    $this->db->from('epupils a');
    $this->db->join('eschoolyear_by_worker_students b','b.studentId = a.pupilsId','left');
    $this->db->order_by('studentName','asc');
    $this->db->where('b.YearId',$YearId);
    $this->db->where('b.workersId',$workersId  );
    $query = $this->db->get();
    return $query->result();
  }

  public function save($data)
  {
    // code...
    if (!empty($data->pupilsId)) {
      // code...
      return $this->update($data);
    }else{
      return $this->add($data);
    }
  }

  public function add($data)
  {
    // code...
    $this->db->insert('epupils',$data);
    return $this->db->insert_id();

    
  }

  public function update($data)
  {
    // code...
    $this->db->where('pupilsId',$data->pupilsId);
    return $this->db->update('epupils',$data);
    //return $this->db->insert_id();

    
  }
  
  public function if_nameexist($data){
    $this->db
        ->select('*')
        ->where('fName',$data->fName)
        ->where('mName',$data->mName)
        ->where('lName',$data->lName);
        $query = $this->db->get('epupils');
        $result = $query->result();
        return $result;


  }
  public function find($keys='')
  {
    // code...
    $query =  $this->db->select("pupilsId as id, CONCAT(fName,' ', mName,' ', lName,' ', ext) as student_name,age,gender,address")
    ->from('epupils')
    ->like('keywords',metaphone($keys))
    ->or_like('keywords_2',metaphone($keys))
    ->or_like('fName',$keys)
    ->or_like('lName',$keys)
    ->get();
    return $query->result();
  }

  public function check_names($keys=array())
  {
    // code...
    $query =  $this->db->select("pupilsId as student_id, CONCAT(fName,' ', mName,' ', lName,' ', ext) as student_name,age,gender,address,epupils.status,workersId as worker_id")
    ->from('epupils')
    ->join('eschoolyear_by_worker_students','eschoolyear_by_worker_students.studentId = epupils.pupilsId','LEFT')
    ->where('fName',$keys['fName'])
    ->where('lName',$keys['lName'])
    ->get();
    if($result = $query->result()){
      foreach ($result as $key => $value) {
        // code...
        $result[$key]->student_status = student_status($value->status);
      }
      return $result;
    }
    return 0;
  }
  private function get_weight($id)
  {
    # code...
    $sql = $this->db->select('weight')
            ->from('e_weighing')
            ->where('student_id',$id)
            ->order_by('date_weighing','desc')
            ->limit(1);
            $query = $this->db->get();
            if ($row = $query->row(0)) {
              # code...
              return $row->weight;
            }
            return 0;

  }
  private function get_height($id)
  {
    # code...

    # code...
    $sql = $this->db->select('height')
            ->from('e_weighing')
            ->where('student_id',$id)
            ->order_by('date_weighing','desc')
            ->limit(1);
            $query = $this->db->get();
            if ($row = $query->row(0)) {
              # code...
              return $row->height;
            }
            return 0;

  }
  public function info($id=0)
  {
    // code...

    $this->db->select("*");
    $this->db->from('epupils');
    $this->db->where('pupilsId',$id);
    $query = $this->db->get();
    $result = $query->row(0);

        $result->weight = $this->get_weight($id);
        $result->height = $this->get_height($id);
          # code...
          $result->f_fName = '';
          $result->f_mName = '';
          $result->f_lName = '';
          $result->f_ext = '';
          # code...
          $result->m_fName = '';
          $result->m_mName = '';
          $result->m_lName = '';
          $result->m_ext = '';
        
    $parents = $this->db->get_where('eparent',array('child_id'=>$id))->result();
    if (!empty($parents)) {
      # code...
      foreach ($parents as $key => $value) {
        # code...
        if ($value->familyPosition == 'father') {
          # code...
          $result->f_fName = $value->fName;
          $result->f_mName = $value->mName;
          $result->f_lName = $value->lName;
          $result->f_ext = $value->ext;
        }

        if ($value->familyPosition == 'mother') {
          # code...
          $result->m_fName = $value->fName;
          $result->m_mName = $value->mName;
          $result->m_lName = $value->lName;
          $result->m_ext = $value->ext;
        }
      }
    }
    return $result;
  }

  public function get_name($id=0)
  {
    // code...
    $row= $this->db->get_where('estudents',array('student_id'=>$id))->row(0);
    return $row->student_name;
  }
  
  
  public function resetall($value='')
  {
    // code...
    $result = $this->db->get('epupils')->result();
    foreach ($result as $key => $value) {
      // code...
      $keywords = metaphone($value->fName.' '.$value->lName);
      $this->db->set('keywords_2',$keywords);
      $this->db->where('pupilsId',$value->pupilsId);
      $this->db->update('epupils');
    }
  }




  ///immunizations


  public function getimmunizations($id){
    return $this->db->order_by('date_immunization','DESC')->get_where('e_immunization',array('student_id'=>$id))->result();
  }
  public function checkimmunizations($data){
    return $this->db->get_where('e_immunization',$data)->result();
  }
  public function addimmunizations($data)
  {
    // code...
  return $this->db->insert('e_immunization',$data);
  }

  public function updateimmunizations($data)
  {
    // code...
        $this->db->where('id',$data->id);
  return $this->db->update('e_immunization',$data);
  }
  ////feeding

  public function getfeeding($id){
    return $this->db->get_where('e_feeding',array('student_id'=>$id))->result();
  }
  public function checkfeeding($data){
    return $this->db->get_where('e_feeding',$data)->result();
  }
  public function addfeeding($data)
  {
    // code...
  return $this->db->insert('e_feeding',$data);
  }
  
  public function updatefeeding($data)
  {
    // code...
        $this->db->where('id',$data->id);
  return $this->db->update('e_feeding',$data);
  }
  public function listfeedingbyyear($year_id='',$date_feeding=0)
  {
    // code...
    return $this->db->get('e_feeding')->result();
  }

 public function get_checklist($value='')
 {
   // code...

  
 }
 public function parents($data,$update=false)
 {
   // code...

  if ($this->db->get_where('eparent',array('child_id'=>$data['child_id'],'familyPosition'=>$data['familyPosition']))->result()) {
    # code...
    $this->db->where('familyPosition',$data['familyPosition']);
    $this->db->where('child_id',$data['child_id']);
   return $this->db->update('eparent',$data);
  }
  return $this->db->insert('eparent',$data);
 
 }


 } 

?>